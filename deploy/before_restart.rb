run "echo ~~~ Running Custom Before Restart Hooks..."

run "echo Working on #{node[:environment][:framework_env]} environment."

current_environment = node[:environment][:framework_env]


# If it's not a production environment, tell robots to not crawl the site
if current_environment != "production"
  run "echo Activate Ignore All robot.txt"
  run "mv #{current_path}/public/robots.txt.ignore.all #{current_path}/public/robots.txt"
end

# Link to Hoptoad Config In Staging and Production
if current_environment == "production" || current_environment == "staging"
  run "ln -nfs #{shared_path}/config/initializers/hoptoad.rb #{release_path}/config/initializers/hoptoad.rb"
end

run "echo ~~~ Custom Before Restart Hooks Complete..."
