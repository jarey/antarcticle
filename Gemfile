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
# new relic performancy monitor
#gem 'newrelic_rpm', '3.5'
# production server
#gem 'unicorn', '4.6.0'
platform :jruby do
  gem 'puma'
end


#platform :jruby do
#  gem 'jruby-openssl'
#end

group :production do
  # production db driver
  platform :jruby do
    gem 'activerecord-jdbcmysql-adapter'
  end
end

group :development, :test do
  # development and testing db driver
  gem 'activerecord-jdbcsqlite3-adapter'
  # testing with rspecs
  gem 'rspec-rails'
end

group :development do
  # n+1 and other db performance issues detector
  gem 'bullet'
  # mutes assets pipeline log messages
  gem 'quiet_assets'
  # better server for development
  #gem 'thin'
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

group :js_env do
  # js environment
  #gem 'libv8', '3.11.8.13'
  #gem 'execjs'
  #gem 'therubyracer', '0.11.3'
  #
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  platform :jruby do
    gem 'therubyrhino'
  end
end

