# rvm installation type
set :rvm_type, :user

# branch to be deployed
set :branch, "master"

server '5.9.40.180', :app, :web, :db, :primary => true
