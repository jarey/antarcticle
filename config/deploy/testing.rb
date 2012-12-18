# rvm installation type
set :rvm_type, :system

# branch to be deployed
set :branch, "develop"

server 'jtalks.org', :app, :web, :db, :primary => true

set :relative_url_root, '/antarcticle'

# compile assets with given relative root
set :asset_env, "RAILS_GROUPS=assets RAILS_RELATIVE_URL_ROOT='#{relative_url_root}'"
