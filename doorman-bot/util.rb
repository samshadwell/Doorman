# frozen_string_literal: true

require 'singleton'

module DoormanBot
  # Utility class which encompasses most of the non-Slack logic used by Doorman.
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

    def refresh_channels!
      # TODO: Implement this.
      @channels = {}.freeze
    end
  end
end
