#
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# Disable iptables
service "iptables" do
  action [ :disable, :stop ]
end

# add exclude param to yum.conf
ruby_block "edit yum.conf" do
  block do
    _file = Chef::Util::FileEdit.new('/etc/yum.conf')
    _file.insert_line_if_no_match("exclude=", "exclude=kernel* centos*")
    _file.write_file
  end
end

template "install.repo" do
  path "/etc/yum.repos.d/install.repo"
  source "install.repo.erb"
  owner "root"
  group "root"
  mode 0644
end

# yum update
execute "yum-update" do
  user "root"
  command "/usr/bin/yum -y update"
  action :run
end