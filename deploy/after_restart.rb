run "echo ~~~ Custom After Restart Hooks - Begin..."
run "echo Working on #{node[:environment][:framework_env]} environment."

notify_deploy_environments = %w(staging production integration)
notify_deploy_roles        = %w(solo app_master)

if notify_deploy_environments.include?(@configuration[:environment]) && notify_deploy_roles.include?(node['instance_role'])
  # Notify Hoptoad of deploy
  run "echo Setting up AirBrake to send deployment information..."
  run "cd #{release_path} && bundle exec rake hoptoad:deploy TO=#{@configuration[:environment]} REVISION=#{@configuration[:revision]} REPO=#{@configuration[:repository]}"
  run "echo Finished setting up AirBrake to send deployment information"
end

run "echo ~~~ Custom After Restart Hooks - Complete"