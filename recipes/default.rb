include_recipe "nodejs"
include_recipe "runit"
include_recipe "statsd::install"
include_recipe "statsd::config"

template "#{node["statsd"]["conf_dir"]}/config.js" do
  mode "0644"
  source "config.js.erb"
  notifies :restart, "service[statsd]", :delayed
end

user node["statsd"]["username"] do
  system true
  shell "/bin/false"
end

runit_service "statsd" do
  action [:enable, :start]
  default_logger true
  options ({
    :user => node['statsd']['username'],
    :statsd_dir => node['statsd']['dir'],
    :conf_dir => node['statsd']['conf_dir'],
    :nodejs_dir => node['nodejs']['dir']                    
  })
end
