#!/bin/bash
bundle check || bundle install
bundle exec rails db:create
bundle exec rails db:migrate:reset
bundle exec rails db:migrate
bundle exec rails db:prepare

if [ -f /app_test/tmp/pids/server.pid ]; then
  echo "Removing server.pid"
  rm /app_test/tmp/pids/server.pid
fi
bundle exec rails s -p 3000 -b '0.0.0.0'
