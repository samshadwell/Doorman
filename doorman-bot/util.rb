# frozen_string_literal: true

require 'set'
require 'singleton'
require 'yaml'

module DoormanBot
  # Utility class which encompasses most of the command-agnostic logic.
  class Util
    include Singleton

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

    def guest_lists
      # Memoize guest lists since these cannot change unless app is redeployed.
      @guest_lists ||=
        Dir.entries(DoormanBot::GUESTS_DIRECTORY)
           .select { |filename| filename.end_with? '.yml' }
           .map { |filename| filename.chomp('.yml') }
           .sort
    end

    private

    def initialize
      @channels = {}.freeze
      @group_members = {}
      refresh_channels!
    end

    # The Slack API doesn't support looking up channels by name and we need the
    # IDs to send invitations. Cache the results of getting all channels and
    # groups (private channels) to minimize the number of times we fetch these
    # from Slack.
    def refresh_channels!
      client = ::Slack::Web::Client.new
      all_groups = client.groups_list.groups
      all_groups.each { |g| @group_members[g.id] = g.members }

      all_channels = client.channels_list.channels
      name_to_id = {}
      (all_channels + all_groups).each do |c|
        name_to_id[c.name] = c.id
      end

      @channels = name_to_id.freeze
    end

    # Given the name of some guest list, returns a list of channel IDs that are
    # included by that guest list.
    def get_target_ids(list_name)
      names = get_target_names(list_name)
      translate_names_to_ids(names)
    end

    def can_invite_to_group?(current_user, group_id)
      @group_members[group_id].include?(current_user)
    end

    def parse_guest_list(list_name)
      filename = "#{DoormanBot::GUESTS_DIRECTORY}/#{list_name}.yml"
      {
        INHERIT_KEY => [],
        INCLUDE_KEY => [],
      }.merge(YAML.load_file(filename))
    end

    def translate_names_to_ids(channel_names)
      channel_names.map do |name|
        refresh_channels! unless channels.key?(name)
        channels.fetch(name)
      end
    end
  end
end
