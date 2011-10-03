if node[:name] == 'solr'
  require_recipe "solr"
end

require_recipe "nginx-configuration"
