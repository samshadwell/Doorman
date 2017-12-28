# frozen_string_literal: true

module DoormanBot
  module Commands
    # List command, fetches all groups known groups and sends to user.
    class List < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        all = Dir.entries(DoormanBot::GUESTS_DIRECTORY)
                 .select { |filename| filename.end_with? '.yml' }
                 .map { |filename| filename.chomp('.yml') }
                 .sort

        client.say(channel: data.channel, text: all)
      end
    end
  end
end
