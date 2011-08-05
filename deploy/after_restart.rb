run "echo '~~~ Custom After Restart Hooks - Begin...'"
run "echo 'Working on #{node[:environment][:framework_env]} environment.'"

notify_deploy_environments = %w(staging production integration)
notify_deploy_roles        = %w(solo app_master)

if notify_deploy_environments.include?(@configuration[:environment]) && notify_deploy_roles.include?(node['instance_role'])
  # Notify Hoptoad of deploy
  run "echo 'Setting up AirBrake to send deployment information...'"
  run "echo '  TO: #{@configuration[:environment].strip}'"
  run "echo '  REVISION: #{@configuration[:revision].strip}'"
  run "echo '  REPO: #{@configuration[:repo].strip}'"
  run "echo '  USER: `whoami`'"
  run "echo '  cd #{release_path} && bundle exec rake hoptoad:deploy TO=#{@configuration[:environment].strip} REVISION=#{@configuration[:revision].strip} USER=`whoami` REPO=#{@configuration[:repo].strip}'"
  run "cd #{release_path} && bundle exec rake hoptoad:deploy TO=#{@configuration[:environment].strip} REVISION=#{@configuration[:revision].strip} USER=`whoami` REPO=#{@configuration[:repo].strip}"
  run "echo 'Finished setting up AirBrake to send deployment information'"
end

run "echo '~~~ Custom After Restart Hooks - Complete'"