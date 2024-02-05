#!/bin/bash
bundle check || bundle install

if bundle exec rails db:migrate:status; then
  echo "Database exists"
else
  echo "Database does not exist, creating..."
  bundle exec rails db:create
fi

if bundle exec rails db:migrate:status | grep 'down'; then
  echo "New migration found, updating database..."
  bundle exec rails db:migrate
else
  echo "No new migration found"
fi

bundle exec rails db:prepare

if [ -f /app_test/tmp/pids/server.pid ]; then
  echo "Removing server.pid"
  rm /app_test/tmp/pids/server.pid
fi
bundle exec rails s -p 3000 -b '0.0.0.0'
