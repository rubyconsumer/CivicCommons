#
# Cookbook Name:: nginx-configuration
# Recipe:: default
#

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
      :environment => node[:environment][:name]
    )
    
  end
end


service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :reload ]
end

