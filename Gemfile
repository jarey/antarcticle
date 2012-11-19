source 'https://rubygems.org'

gem 'rails', '3.2.8'
# jquery
gem 'jquery-rails'
# sass version of twitter bootstrap
gem "bootstrap-sass", "~> 2.1.1.0"
# fake data generator for filling database
gem "faker", "~> 1.1.2"
# markdown processor
gem 'redcarpet', '2.2.2'
# serving pagination
gem 'will_paginate', '3.0.3'
# using bootstrap
gem 'bootstrap-will_paginate', '0.0.9'
# authorization
gem 'cancan', '1.6.8'
# tags
gem 'acts-as-taggable-on', '2.3.3'

group :production do
  # production db driver
  gem 'mysql2'
end

group :development, :test do
  # development and testing db driver
  gem 'sqlite3', '1.3.5'
  # testing with rspecs
  gem 'rspec-rails', '2.11.0'
  # running tests faster
  gem 'spork-rails'
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
end

group :test do
  # testing by simulating user interaction
  gem 'capybara', '~> 1.1.3'
  # factories for test data
  gem 'factory_girl_rails', '4.1.0'
end

group :assets do
  # sass stylesheet language
  gem 'sass-rails',   '~> 3.2.5'
  # coffescript
  gem 'coffee-rails', '~> 3.2.2'
  # additional icon font to use with bootstrap
  gem 'font-awesome-sass-rails'

  # js compressor
  gem 'uglifier', '>= 1.2.3'

  # js environment
  gem 'execjs'
  gem 'therubyracer'
end

