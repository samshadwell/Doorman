# frozen_string_literal: true

module DoormanBot
  module Commands
    # List command, fetches all groups known groups and sends to user.
    class List < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        guest_lists = DoormanBot::Util.instance.guest_lists
        channels = DoormanBot::Util.instance.channels
        response_text =
          "Guest lists: #{guest_lists}
           Channels: #{channels}"
        client.say(channel: data.channel,
                   text: response_text)
      end
    end
  end
end
