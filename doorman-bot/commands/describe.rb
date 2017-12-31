# frozen_string_literal: true

module DoormanBot
  module Commands
    # List command, fetches all groups known groups and sends to user.
    class Describe < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        client.say(channel: data.channel,
                   text: 'Describe this boiii')
      end
    end
  end
end
