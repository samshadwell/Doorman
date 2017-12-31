# frozen_string_literal: true

module DoormanBot
  module Commands
    # List command, fetches all groups known groups and sends to user.
    class Describe < SlackRubyBot::Commands::Base
      # TODO: MVC-ify this. All this text logic should be in a view.
      MISSING_LIST_RESPONSE =
        "I'm sorry, you need to provide a guest list to describe. For more " \
        'information try `doorman help describe`'

      INVALID_LIST_RESPONSE =
        "It looks like the list you're trying to describe doesn't exist."

      match(/^(?<bot>\w*)\sdescribe(\s(?<list>\w*))?/) do |client, data, match|
        if match['list'].nil?
          respond_in_thread(client, data, MISSING_LIST_RESPONSE)
        else
          list = match['list'].strip
          available_lists = DoormanBot::Util.instance.guest_lists
          if available_lists.include?(list)
            invites_to = DoormanBot::Util.instance.get_target_names(list)
            response_lines = ["The guest list `#{list}` sends invitations to:"]
            response_lines += invites_to.map do |l|
              DoormanBot::LIST_LINE_BEGIN + l
            end

            respond_in_thread client, data, response_lines.join("\n")
          else
            respond_in_thread client, data, INVALID_LIST_RESPONSE
          end
        end
      end
    end
  end
end
