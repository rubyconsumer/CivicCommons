run "echo ~~~ Custom Before Restart Hooks - Begin..."
run "echo Working on #{node[:environment][:framework_env]} environment."

current_environment = node[:environment][:framework_env]

# setup the correct timezone: http://docs.engineyard.com/set-time-zone-for-an-appcloud-instance.html
# http://www.timezoneconverter.com/cgi-bin/zoneinfo.tzc?s=default&tz=EST5EDT
# run "sudo ln -sf /usr/share/zoneinfo/EST5EDT /etc/localtime"

# If it's not a production environment, tell robots to not crawl the site
if current_environment != "production"
  run "echo Activate Ignore All robot.txt..."
  run "mv #{current_path}/public/robots.txt.ignore.all #{current_path}/public/robots.txt"
else
  run "echo Activate Ignore All robot.txt... IGNORE"
end

# Link to Airbrake Config In Staging and Production
if current_environment == "production" || current_environment == "staging"
  run "echo Config Airbrake Connection..."
  run "ln -nfs #{shared_path}/config/initializers/airbrake.rb #{release_path}/config/initializers/airbrake.rb"
else
  run "echo Config Airbrake Connection....... IGNORE"
end

# restart delayed_job process
run "echo 'Restarting delayed_job process...'"
run "echo '  cd #{release_path} && bundle exec script/delayed_job restart'"
run "cd #{release_path} && bundle exec script/delayed_job restart"
run "echo 'Finished restarting delayed_job process.'"

# restart and reindex solr process
if current_environment != "production"
  run "echo 'Starting solr recycling process (stop/start/reindex).'"

  run "echo Listing Current Solr Processes..."
  run "echo '  ps aux | grep solr'"
  run "        ps aux | grep solr"

  run "echo '* Stopping previous solr process...'"
  run "echo '  cd #{previous_release} && bundle exec rake sunspot:solr:stop'"
  run "        cd #{previous_release} && bundle exec rake sunspot:solr:stop"

  run "echo Listing Current Solr Processes..."
  run "echo '  ps aux | grep solr'"
  run "        ps aux | grep solr"

  run "echo '* Starting solr process...'"
  run "echo '  cd #{release_path} && bundle exec rake sunspot:solr:start'"
  run "        cd #{release_path} && bundle exec rake sunspot:solr:start"

  run "echo Listing Current Solr Processes..."
  run "echo '  ps aux | grep solr'"
  run "        ps aux | grep solr"

  run "echo '* Reindexing with solr...'"
  run "echo '  cd #{release_path} && bundle exec rake sunspot:solr:reindex'"
  run "        cd #{release_path} && bundle exec rake sunspot:solr:reindex"

  run "echo 'Finished solr recycling process.'"
end

run "echo ~~~ Custom Before Restart Hooks - Complete..."
