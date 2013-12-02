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

node["statsd"]["backends"]["enabled"].each do |backend|
  conf = node["statsd"]["backends"][backend]

  # assuming that the backend is the built-in one, we enable it
  if conf.nil?
    backends << "./backends/#{backend}"; next
  end

  case conf["install_method"]
  when "remote_file"
    remote_file backend do
      mode    0644
      path    "#{node['statsd']['dir']}/backends/#{backend}.js"
      source  conf["uri"]
    end
    backends << "./backends/#{backend}"
  else
    raise NotImplementedError, "[statsd] backend install method `#{conf['install_method']} not supported'"
  end
end
