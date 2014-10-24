#
# Cookbook Name:: zabbix
# Recipe:: paco
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
user "zabbix" do
  uid 10050
  shell "/sbin/nologin"
  password nil
  supports :manage_home => false
end

group "zabbix" do
  gid 10050
  members ['zabbix']
  action :create
end

group "adm" do
  action :modify
  members "zabbix"
  append true
end

download_zabbix_agent_file = "#{Chef::Config[:file_cache_path]}/#{File.basename(node.zabbix_agent.source)}"
remote_file download_zabbix_agent_file do
  source node[:zabbix_agent][:source]
  owner 'root'
  group 'root'
  mode  '0644'
  not_if { FileTest.file? download_zabbix_agent_file }
end

# Install zabbix-agent
script "install_zabbix_agent" do
  not_if { File.exists?("/usr/local/sbin/zabbix_agent") }
  interpreter "bash"
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOL
    tar zxvf #{Chef::Config[:file_cache_path]}/#{File.basename(node.zabbix_agent.source)}
    cd #{Chef::Config[:file_cache_path]}/#{File.basename(node.zabbix_agent.source, '.tar.gz')}
    ./configure #{node.zabbix_agent.opt.join(' ')}
     make -j$(expr `grep '^processor' /proc/cpuinfo | wc -l` + 1)
     #{node.paco.bin} -D make install 
  EOL
end

directory "/var/run/zabbix" do
  owner "zabbix"
  group "zabbix"
  mode 0755
  action :create
end

directory "/var/log/zabbix" do
  owner "zabbix"
  group "zabbix"
  mode 0755
  action :create
end

template "zabbix_agentd.conf" do
  path "/usr/local/etc/zabbix_agentd.conf"
  owner "root"
  source "zabbix/zabbix_agentd.conf.erb"
end

cookbook_file "/etc/init.d/zabbix_agentd" do
  source "zabbix/zabbix_agentd"
  mode 0755
end

service "zabbix_agentd" do
  supports :start => true, :restart => true
  action [ :enable, :start ]
  subscribes :restart, "template[zabbix_agentd.conf]"
end