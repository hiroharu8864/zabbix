zabbix Cookbook
===============
CentOSのvagrant環境にzabbix-agentをインストールする。

Requirements
------------
#### zabbix-agentインストール

```json
{
  "epel":{
    "OSRELEASE":"6"
  },
  "zabbix":{
    "OSRELEASE":"6",
    "agent_source_ip":"zabbix agent IP address",
    "manage_source_ip":"zabbix manager IP address"
  },
  "run_list":[
    "recipe[zabbix::default]",
    "recipe[zabbix::paco]",
    "recipe[zabbix::monit]",
    "recipe[zabbix::zabbix_agent]"
  ]
}
```

Overview
------------
```
# zabbix_agentd --version
Zabbix Agent (daemon) v2.0.6 (revision 35158) (22 April 2013)
Compilation time: Oct  9 2014 09:03:33

# paco -a
zabbix-2.0.6
```

monitによるプロセス監視

License and Authors
-------------------
Authors: Hiroharu Tanaka
