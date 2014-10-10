default[:zabbix_agent] = {
    :source => 'http://jaist.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.0.6/zabbix-2.0.6.tar.gz',
    :opt    => [
        '--with-ssh2',
        '--enable-agent',
  ],
}
default[:paco] = {
  :bin    => '/usr/bin/paco',
}
default[:monit][:web_server] = {
  'zabbix_agentd' => {
    'process' => 'zabbix_agentd',
    'pidfile' => '/var/run/zabbix/zabbix_agentd.pid'
  },
}