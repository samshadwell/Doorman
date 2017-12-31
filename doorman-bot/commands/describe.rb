# frozen_string_literal: true

module DoormanBot
  module Commands
    # List command, fetches all groups known groups and sends to user.
    class Describe < SlackRubyBot::Commands::Base
      match(/^(?<bot>\w*)\sdescribe(\s(?<list>\w*))?/) do |client, data, match|
        response_text = nil
        if match['list'].nil?
          response_text = DoormanBot::MISSING_LIST_RESPONSE
        else
          list = match['list'].strip
          available_lists = DoormanBot::Util.instance.guest_lists
          if available_lists.include?(list)
            invites_to = DoormanBot::Util.instance.get_target_names(list)
            response_text = DoormanBot::TextFactory.describe_response(
              list,
              invites_to
            )
          else
            response_text = DoormanBot::INVALID_LIST_RESPONSE
          end
        end

        respond_in_thread client, data, response_text
      end
    end
  end
end
