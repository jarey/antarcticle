source 'https://rubygems.org'

gem 'rails', '3.2.13'
# jquery
gem 'jquery-rails'
# sass version of twitter bootstrap
gem 'bootstrap-sass'
# fake data generator for filling database
gem 'ffaker'
# markdown processor
#gem 'redcarpet'
gem 'kramdown'
# serving pagination
gem 'will_paginate'
# using bootstrap
gem 'bootstrap-will_paginate'
# authorization
gem 'cancan'
# tags
gem 'acts-as-taggable-on'
# production server
gem 'unicorn', :platform => :ruby
gem 'puma', :platform => :jruby

# war building tool
gem 'warbler', :platform => :jruby

group :production do
  # production db driver
  gem 'activerecord-jdbcmysql-adapter', :platform => :jruby
  gem 'mysql2', :platform => :ruby
end

group :development, :test do
  # development and testing db driver
  gem 'activerecord-jdbcsqlite3-adapter', :platform => :jruby
  gem 'sqlite3', :platform => :ruby
  # testing with rspecs
  gem 'rspec-rails'
end

group :development do
  # n+1 and other db performance issues detector
  gem 'bullet'
  # mutes assets pipeline log messages
  gem 'quiet_assets'
  # better server for development
  gem 'thin', :platform => :ruby
  # deployment scripting
  gem 'capistrano'
  gem 'rvm-capistrano'
  # better error page
  gem 'better_errors'
end

group :test do
  # testing by simulating user interaction
  gem 'capybara'
  # factories for test data
  gem 'factory_girl_rails'
  # testing external http requests
  gem 'webmock'
end

group :assets do
  # sass stylesheet language
  gem 'sass-rails'
  # coffescript
  gem 'coffee-rails'
  # additional icon font to use with bootstrap
  gem 'font-awesome-sass-rails'
  # speed up assets compilation
  gem 'turbo-sprockets-rails3'
  # js compressor
  gem 'uglifier'
end

# JavaScript environment
group :js_env do
  gem 'therubyrhino', :platform => :jruby
  gem 'therubyracer', :require => 'v8', :platform => :ruby
end

