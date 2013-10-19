require 'capistrano'
require 'capistrano-unicorn'
# 1. Add `gem 'capistrano', '~> 2.15'` to your Gemfile.
# 2. Run `bundle install --binstubs --path=vendor/bundles`.
# 6. Run `git commit -a -m "Configured capistrano deployments."`.
# 7. Run `git push origin master`.
# 8. Run `bin/cap deploy:setup`.
# 9. Run `bin/cap deploy:migrations` or `bin/cap deploy`.
#
GITHUB_REPOSITORY_NAME = 'r13-team-346'
LINODE_SERVER_HOSTNAME = '173.255.246.116'
# General Options
 
set :bundle_flags,               "--deployment"
 
set :application,                "pugwarriors"
set :deploy_to,                  "/var/www/apps/railsrumble"
set :normalize_asset_timestamps, false
set :rails_env,                  "production"
 
set :user,                       "root"
set :runner,                     "www-data"
set :admin_runner,               "www-data"
 
ssh_options[:keys] = ["~/.ssh/id_rsa"]
 
set :scm,        :git
set :repository, "git@github.com:railsrumble/#{GITHUB_REPOSITORY_NAME}.git"
set :branch,     "master"
 
# Roles
role :app, LINODE_SERVER_HOSTNAME
role :db,  LINODE_SERVER_HOSTNAME, :primary => true
 
# Add Configuration Files & Compile Assets
after 'deploy:update_code' do
  # Setup Configuration
  run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
 
  # Compile Assets
  run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
end
 
# Restart Passenger
deploy.task :restart, :roles => :app do
  # Fix Permissions
  sudo "chown -R www-data:www-data #{current_path}"
  sudo "chown -R www-data:www-data #{latest_release}"
  sudo "chown -R www-data:www-data #{shared_path}/log"
 
  # Restart Application
  unicorn.restart
end
