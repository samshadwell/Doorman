# frozen_string_literal: true

module DoormanBot
  module Commands
    # List command, fetches all groups known groups and sends to user.
    class List < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        guest_lists = DoormanBot::Util.instance.guest_lists
        response_text = DoormanBot::TextFactory.list_response(guest_lists)

        respond_in_thread client, data, response_text
      end
    end
  end
end
