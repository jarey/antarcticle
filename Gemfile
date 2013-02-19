source 'https://rubygems.org'

gem 'rails', '3.2.12'
# jquery
gem 'jquery-rails', '2.2.1'
# sass version of twitter bootstrap
gem "bootstrap-sass", "2.3.0"
# fake data generator for filling database
gem "ffaker"
# markdown processor
gem 'redcarpet', '2.2.2'
# serving pagination
gem 'will_paginate', '3.0.4'
# using bootstrap
gem 'bootstrap-will_paginate', '0.0.9'
# authorization
gem 'cancan', '1.6.9'
# tags
gem 'acts-as-taggable-on', '2.3.3'
# new relic performancy monitor
gem 'newrelic_rpm', '3.5'
# production server
gem 'unicorn', '4.6.0'

group :production do
  # production db driver
  gem 'mysql2'
end

group :development, :test do
  # development and testing db driver
  gem 'sqlite3', '1.3.7'
  # testing with rspecs
  gem 'rspec-rails', '2.12.2'
end

group :development do
  # n+1 and other db performance issues detector
  gem 'bullet'
  # mutes assets pipeline log messages
  gem 'quiet_assets'
  # better server for development
  gem 'thin'
  # deployment scripting
  gem 'capistrano'
  gem 'rvm-capistrano'
  # better error page
  gem 'better_errors'
end

group :test do
  # testing by simulating user interaction
  gem 'capybara', '2.0.2'
  # factories for test data
  gem 'factory_girl_rails', '4.2.0'
  # testing external http requests
  gem 'webmock'
end

group :assets do
  # sass stylesheet language
  gem 'sass-rails',   '~> 3.2.5'
  # coffescript
  gem 'coffee-rails', '~> 3.2.2'
  # additional icon font to use with bootstrap
  gem 'font-awesome-sass-rails'
  # speed up assets compilation
  gem 'turbo-sprockets-rails3', '0.3.6'
  # js compressor
  gem 'uglifier', '>= 1.2.3'
end

group :js_env do
  # js environment
  gem 'libv8', '3.11.8.13'
  gem 'execjs'
  gem 'therubyracer', '0.11.3'
end

