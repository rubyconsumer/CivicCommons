notify_deploy_environments = %w(staging production integration)
notify_deploy_roles        = %w(solo app_master)

if notify_deploy_environments.include?(@configuration[:environment]) && notify_deploy_roles.include?(node['instance_role'])
  # Notify Hoptoad of deploy
  run "cd #{release_path} && rake hoptoad:deploy TO=#{@configuration[:environment]} REVISION=#{@configuration[:revision]} REPO=#{@configuration[:repository]}"
end