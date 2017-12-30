#!/bin/bash

source ./.env
SLACK_API_TOKEN=${SLACK_API_TOKEN} bundle exec ruby ./app/app.rb
