# frozen_string_literal: true

require 'set'
require 'singleton'
require 'yaml'

module DoormanBot
  # Utility class which encompasses most of the command-agnostic logic.
  class Util
    include Singleton

    GROUP_PREFIX = 'G' # All group IDs in Slack start with G.
    INHERIT_KEY = 'inherit-from'
    INCLUDE_KEY = 'include-channels'

    # Given the name of some guest list, returns a list of channel names that
    # are included by that guest list.
    def get_target_names(list_name)
      channel_names = Set.new
      explored = Set.new
      to_do = [list_name]

      until to_do.empty?
        work = to_do.pop
        next if explored.member?(work)

        guest_list = parse_guest_list(work)
        channel_names.merge guest_list[INCLUDE_KEY]
        to_do += guest_list[INHERIT_KEY]

        explored.add work
      end
      channel_names.to_a.sort
    end

    # Returns a list of all available guest lists.
    def guest_lists
      # Memoize guest lists since these cannot change unless app is redeployed.
      @guest_lists ||=
        Dir.entries(DoormanBot::GUESTS_DIRECTORY)
           .select { |filename| filename.end_with? '.yml' }
           .map { |filename| filename.chomp('.yml') }
           .sort
    end

    # Send invitations to 'invited' on behalf of 'inviter' for all the channels
    # included by the given 'list_name'
    def invite_to_list(inviter, invited, list_name)
      name_to_id = get_target_ids(list_name)
      worked = []
      failed = []
      name_to_id.each do |name, id|
        success = attempt_invite(id, invited, inviter)
        if success
          worked << name
        else
          failed << name
        end
      end

      { successful: worked, failed: failed }
    end

    private

    def initialize
      @channels = {}.freeze
      @group_members = {}
      @client = ::Slack::Web::Client.new
      refresh_channels!
    end

    # Given a channel ID, attempt to invite 'invited' on behalf of 'inviter'.
    # Returns true if successful, false otherwise.
    def attempt_invite(channel_id, invited, inviter)
      if channel_id.nil?
        false
      elsif group?(channel_id)
        if can_invite_to_group?(inviter, channel_id)
          invite(invited, channel_id)
        else
          false
        end
      else
        invite(invited, channel_id)
      end
    end

    # Does the given 'current_user' have permission to invite to the given
    # private channel ID?
    def can_invite_to_group?(current_user, group_id)
      @group_members[group_id].include?(current_user)
    end

    # Given the name of some guest list, returns a mapping from the channel
    # names to ids for all channels included by the guest list.
    def get_target_ids(list_name)
      names = get_target_names(list_name)
      translate_names_to_ids(names)
    end

    # Returns true if the given ID is for a group (AKA private channel), false
    # otherwise.
    def group?(id)
      id[0] == GROUP_PREFIX
    end

    # Sends an invitation to the given channel. If successful returns true,
    # otherwise returns false.
    def invite(user, channel)
      status = client.channels_invite(channel: channel, user: user)
      status.ok
    end

    # Given a list name read and parse the appropriate YAML file, returning the
    # resulting hash. This hash is guaranteed to have INHERIT_KEY and
    # INCLUDE_KEY as keys.
    def parse_guest_list(list_name)
      filename = "#{DoormanBot::GUESTS_DIRECTORY}/#{list_name}.yml"
      {
        INHERIT_KEY => [],
        INCLUDE_KEY => [],
      }.merge(YAML.load_file(filename))
    end

    # The Slack API doesn't support looking up channels by name and we need the
    # IDs to send invitations. Cache the results of getting all channels and
    # groups (private channels) to minimize the number of times we fetch these
    # from Slack.
    def refresh_channels!
      all_groups = @client.groups_list.groups
      all_groups.each { |g| @group_members[g.id] = g.members }

      all_channels = @client.channels_list.channels
      name_to_id = {}
      (all_channels + all_groups).each do |c|
        name_to_id[c.name] = c.id
      end

      @channels = name_to_id.freeze
    end

    # Given a list of channel names, returns a hash mapping from the given names
    # to their IDs.
    def translate_names_to_ids(channel_names)
      did_refresh = false
      name_to_id = {}
      channel_names.map do |name|
        if !@channels.key?(name) && !did_refresh
          refresh_channels!
          did_refresh = true
        end
        name_to_id[name] = @channels[name]
      end
      name_to_id
    end
  end
end
