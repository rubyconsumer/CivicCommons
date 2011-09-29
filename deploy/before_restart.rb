run "echo ~~~ Custom Before Restart Hooks - Begin..."
run "echo Working on #{node[:environment][:framework_env]} environment."

current_environment = node[:environment][:framework_env]

# If it's not a production environment, tell robots to not crawl the site
if current_environment != "production"
  run "echo Activate Ignore All robot.txt..."
  run "mv #{current_path}/public/robots.txt.ignore.all #{current_path}/public/robots.txt"
else
  run "echo Activate Ignore All robot.txt... IGNORE"
end

# Link to Hoptoad Config In Staging and Production
if current_environment == "production" || current_environment == "staging"
  run "echo Config Hoptoad Connection..."
  run "ln -nfs #{shared_path}/config/initializers/hoptoad.rb #{release_path}/config/initializers/hoptoad.rb"
else
  run "echo Config Hoptoad Connection....... IGNORE"
end

# restart delayed_job process
run "echo 'Restarting delayed_job process...'"
run "echo '  cd #{release_path} && bundle exec script/delayed_job restart'"
run "cd #{release_path} && bundle exec script/delayed_job restart"
run "echo 'Finished restarting delayed_job process.'"

run "echo ~~~ Custom Before Restart Hooks - Complete..."
