# frozen_string_literal: true

module DoormanBot
  module Commands
    # List command, fetches all groups known groups and sends to user.
    class List < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        client.say(channel: data.channel,
                   text: DoormanBot::Util.instance.guest_lists)
      end
    end
  end
end
