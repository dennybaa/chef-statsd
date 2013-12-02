include_recipe "git"

git node["statsd"]["dir"] do
  repository node["statsd"]["repository"]
  reference node["statsd"]["reference"]
  action :sync
  notifies :restart, "service[statsd]", :delayed
end

directory node["statsd"]["conf_dir"] do
  action :create
end

backends = node.default["statsd"]["backends"]
backends = Array.new

node["statsd"]["plugins"]["enabled"].each do |plugin|
  conf = node["statsd"]["plugins"][plugin]

  # enable built-in plugins
  if conf.nil?
    backends << "./backends/#{plugin}"; next
  end

  case conf["install_method"]
  when "remote_file"
    remote_file plugin do
      mode    0644
      path    "#{node['statsd']['dir']}/backends/#{plugin}.js"
      source  conf["uri"]
    end
    backends << "./backends/#{plugin}"
  else
    raise NotImplementedError, "[statsd] plugin install method `#{conf['install_method']} not supported'"
  end
end
