#
# Cookbook Name:: zabbix
# Recipe:: paco
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# install monit
package "monit" do
  action :install
end

# add logfile param to monit.conf
cookbook_file "/etc/monit.conf" do
  source "monit/monit.conf"
  owner "root"
  group "root"
  mode 0700
end

# add monit supervisord process
node.monit.web_server.each do |k,v|
  template "process_#{v[:process]}_monit.conf" do
    path "/etc/monit.d/#{v[:process]}_monit.conf"
    source "monit/process_monit.conf.erb"
    owner "root"
    group "root"
    mode 0644
    variables({
      :process => "#{v[:process]}",
      :pidfile => "#{v[:pidfile]}"
    })
  end
end

# service restart
service "monit" do
  supports :restart => true, :reload => true
  action [ :start, :enable]
end