plugins = node.default["statsd"]["plugins"]

plugins.zabbix["install_method"]   = "remote_file"
plugins.zabbix["uri"]              = "https://raw.github.com/parkerd/statsd-zabbix-backend/master/lib/zabbix.js"
