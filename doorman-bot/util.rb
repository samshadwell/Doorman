# frozen_string_literal: true

require 'singleton'

module DoormanBot
  # Utility class which encompasses most of the command-agnostic logic.
  class Util
    include Singleton

    # @channels is a hash mapping channel names to their IDs
    attr_reader :channels

    def initialize
      refresh_channels!
    end

    def guest_lists
      # Memoize guest lists since these cannot change unless app is redeployed.
      @guest_lists ||=
        Dir.entries(DoormanBot::GUESTS_DIRECTORY)
           .select { |filename| filename.end_with? '.yml' }
           .map { |filename| filename.chomp('.yml') }
           .sort
    end

    # The Slack API doesn't support looking up channels by name and we need the
    # IDs to send invitations. Cache the results of getting all channels and
    # groups (private channels) to minimize the number of times we fetch these
    # from Slack.
    def refresh_channels!
      client = Slack::Web::Client.new
      all_channels = client.channels_list.channels
      all_channels += client.groups_list.groups
      name_to_id = {}
      all_channels.each do |c|
        name_to_id[c.name] = c.id
      end

      @channels = name_to_id.freeze
    end
  end
end
