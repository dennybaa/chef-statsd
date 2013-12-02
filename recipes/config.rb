
def opt4statsd(str); str.gsub(/_(\w)/).each {|m| $1.upcase}; end

config = node.default["statsd"]["config"]
%w(
  address
  port
  flush_interval
  percent_threshold
  delete_idle_stats
  delete_gauges
  delete_timers
  delete_sets
  delete_counters
).each do |o|
  config[opt4statsd(o)] = node['statsd'][o]
end

plugin_opts = {
  graphite: %w(graphite_host graphite_port),
  zabbix:   %w(zabbix_host zabbix_port zabbix_sender) 
}

enabled = node["statsd"]["plugins"]["enabled"]
enabled = ['graphite'] if enabled.empty?

# Configure backend specific options
enabled.each do |plugin|
  (plugin_opts[plugin.to_sym] || []).each do |o|
    config[opt4statsd(o)] = node['statsd'][o]
  end

  bndcf = node["statsd"][plugin]
  config[plugin] = bndcf unless bndcf.nil? || bndcf.empty?
end

if enabled.include?("graphite")
  unless Chef::Config[:solo] || node['statsd']['graphite_query'].to_s.empty?
    addr = search(:node, node['statsd']['graphite_query']).first['ipaddress'] rescue nil
    addr and config[:graphiteHost] = addr
  end
end

