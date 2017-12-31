# frozen_string_literal: true

module DoormanBot
  module Commands
    # List command, fetches all groups known groups and sends to user.
    class List < SlackRubyBot::Commands::Base
      RESPONSE_BEGINNING = 'Here are all the guest lists I am aware of:'
      EACH_LIST_BEGIN = ' • '

      def self.call(client, data, _match)
        guest_lists = DoormanBot::Util.instance.guest_lists
        all_lines = [RESPONSE_BEGINNING] + guest_lists.map do |l|
          EACH_LIST_BEGIN + l
        end

        client.say(channel: data.channel,
                   text: all_lines.join("\n"),
                   thread_ts: data.thread_ts || data.ts)
      end
    end
  end
end
