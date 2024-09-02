#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate

# マイグレーションの実行
bin/rails db:migrate RAILS_ENV=production