# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'slack-ruby-bot'
require 'doorman-bot/commands'
require 'doorman-bot/constants'
require 'doorman-bot/doorman'

DoormanBot::Doorman.run
