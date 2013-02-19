require 'bundler/capistrano'
require 'rvm/capistrano'
load 'deploy/assets'

# multiple deploy environments
set :stages, %w(testing production)
# default deploy env
set :default_stage, "testing"
require 'capistrano/ext/multistage'

# application name
set :application, "antarcticle"
# VCS type
set :scm, :git
# repository url
set :repository, "git@github.com:jtalks-org/antarcticle.git"

# deployer user
set :user, "antarcticle"
# application path
set :deploy_to, "/home/antarcticle/apps/#{application}"
# don't use sudo in commands
set :use_sudo, false
# remove old releases, keep only last 3
set :keep_releases, 3
# only fetch the changes since the last deploy
#set :deploy_via, :remote_cache

# skip test and development dependencies
set :bundle_without, [:development, :test]
set :relative_url_root, nil

# unicorn management
namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      command = "upgrade" if command == "restart"
      run "/etc/init.d/unicorn_#{application} #{command}" # Using unicorn as the app server
    end
  end
end

task :symlink_configs do
  # database config
  run "rm #{release_path}/config/database.yml"
  run "ln -sfn #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  # unicorn init script
  unicorn_config = from_template("config/unicorn_antarcticle.sh.erb")
  put unicorn_config, "/etc/init.d/unicorn_#{application}"
  # application config
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

# render template
def from_template(file)
  require 'erb'
  template = File.read(File.join(File.dirname(__FILE__), "..", file))
  result = ERB.new(template).result(binding)
end
