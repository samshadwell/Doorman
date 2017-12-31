# frozen_string_literal: true

module DoormanBot
  # Class which encapsulates the message text generation logic for commands.
  class TextFactory
    def self.describe_response(list, invites_to)
      bulleted_list("The guest list `#{list}` sends invitations to:",
                    invites_to)
    end

    def self.list_response(lists)
      bulleted_list('Here are all the guest lists I am aware of:', lists)
    end

    class << self
      private

      def bulleted_list(first_line, to_list)
        response_lines = [first_line]
        response_lines += to_list.map { |l| DoormanBot::LIST_LINE_BEGIN + l }
        response_lines.join("\n")
      end
    end
  end
end
