run "echo Running Custom Before Restart Hooks..."

# If it's not a production environment, tell robots to not crawl the site
if node[:environment][:framework_env] != "production"
  run "echo Activate Ignore All robot.txt"
  run "mv #{current_path}/public/robots.txt.ignore.all #{current_path}/public/robots.txt"
end

# Link to Hoptoad Config In Staging and Production
if node[:environment][:framework_env] == "production" || node[:environment][:framework_env] == "staging"
  run "ln -nfs #{shared_path}/config/initializers/hoptoad.rb #{release_path}/config/initializers/hoptoad.rb"
end
