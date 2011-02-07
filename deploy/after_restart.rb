run "echo ~~~ Custom After Restart Hooks - Begin..."
run "echo Working on #{node[:environment][:framework_env]} environment."

current_environment = node[:environment][:framework_env]

# Setup cronjobs for the machine from config/schedule.rb
run "echo Updating the crontab on the server"
application = File.basename(current_path) # use the application folder name as the crontab namespace
run "cd #{current_path} && whenever --update-crontab \"#{application}\""

run "echo ~~~ Custom After Restart Hooks - Complete..."