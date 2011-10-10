#
# Cookbook Name:: nginx-configuration
# Recipe:: default
#

hostname = ''
hostname = node[:environment][:name] + '.' if node[:environment][:name] != 'production'

app_name = "TheCivicCommons"
config_file = "/data/nginx/servers/#{app_name}.conf" 
if ['solo', 'app', 'app_master'].include?(node[:instance_role])
  template config_file do
    source "nginx_config.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    variables(
      :app_name => app_name,
      :hostname => hostname,
      :environment_type => node[:environment][:framework_env]
    )
  end
end


service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :reload ]
end

