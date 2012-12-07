require 'bundler/capistrano'
require 'rvm/capistrano'
load 'deploy/assets'

# rvm installation type
set :rvm_type, :system

# application name
set :application, "antarcticle"
# VCS type
set :scm, :git
# repository url
set :repository,  "git@jtalks.org:antarcticle"
# branch to be deployed
set :branch, "develop"

#
#default_run_options[:pty] = true
# deployer user
set :user, "antarcticle"
set :deploy_to, "/home/antarcticle/apps/#{application}"
# don't use sudo in commands
set :use_sudo, false
# remove old releases, keep only last 3
set :keep_releases, 3
# only fetch the changes since the last deploy
set :deploy_via, :remote_cache

role :web, "jtalks.org"                          # Your HTTP server, Apache/etc
role :app, "jtalks.org"                          # This may be the same as your `Web` server
role :db,  "jtalks.org", :primary => true # This is where Rails migrations will run

# compile assets with given relative root
set :asset_env, "RAILS_GROUPS=assets RAILS_RELATIVE_URL_ROOT='/antarcticle'"
# skip test and development dependencies
set :bundle_without, [:development, :test]

# unicorn management
namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}" # Using unicorn as the app server
    end
  end
end

task :symlink_configs do
  # database
  run "rm #{release_path}/config/database.yml"
  run "ln -sfn #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  # unicorn init script
  run "ln -sfn #{shared_path}/config/unicorn_antarcticle.sh /etc/init.d/unicorn_antarcticle"
  # application
  run "ln -sfn #{shared_path}/config/application.yml #{release_path}/config/application.yml"
end
after "bundle:install", "symlink_configs"

# run rake task on server
namespace :rake_ do
  desc "Run a task on a remote server."
  # run like: cap rake_:invoke task=a_certain_task
  task :invoke do
    run("cd #{deploy_to}/current; /usr/bin/env rake #{ENV['task']} RAILS_ENV=#{rails_env}")
  end
end
