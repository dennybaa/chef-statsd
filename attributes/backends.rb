backends = node.default["statsd"]["backends"]

backends.zabbix["install_method"]   = "remote_file"
backends.zabbix["uri"]              = "https://raw.github.com/parkerd/statsd-zabbix-backend/master/lib/zabbix.js"
