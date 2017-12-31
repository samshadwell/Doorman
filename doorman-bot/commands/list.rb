# frozen_string_literal: true

module DoormanBot
  module Commands
    # List command, fetches all groups known groups and sends to user.
    class List < SlackRubyBot::Commands::Base
      RESPONSE_BEGINNING = 'Here are all the guest lists I am aware of:'

      def self.call(client, data, _match)
        guest_lists = DoormanBot::Util.instance.guest_lists
        all_lines = [RESPONSE_BEGINNING] + guest_lists.map do |l|
          DoormanBot::LIST_LINE_BEGIN + l
        end

        respond_in_thread client, data, all_lines.join("\n")
      end
    end
  end
end
