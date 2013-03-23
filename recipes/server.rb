#
# Cookbook Name:: pdns
# Recipe:: server
#
# Copyright 2010, Opscode, Inc.
# Copyright 2013, Gabor Nagy
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


package "pdns" do
  package_name value_for_platform(
    ["debian","ubuntu"] => { "default" => "pdns-server" },
    "default" => "pdns"
  )
end

case node['pdns']['server']['backend']
when "sqlite"
  package "pdns-backend-sqlite3" do
    package_name value_for_platform(
      "arch"                       => { "default" => "pdns" },
      ["debian","ubuntu"]          => { "default" => "pdns-backend-sqlite3" },
      ["redhat","centos","fedora"] => { "default" => "pdns-backend-sqlite3" },
      "default"                    => "pdns-backend-sqlite3"
    )
  end
when "mysql"
  package "pdns-backend-mysql" do
    package_name value_for_platform(
      "arch"                       => { "default" => "pdns" },
      ["debian","ubuntu"]          => { "default" => "pdns-backend-mysql" },
      ["redhat","centos","fedora"] => { "default" => "pdns-backend-mysql" },
      "default"                    => "pdns-backend-mysql"
    )
  end
when "pgsql"
  package "pdns-backend-postgresql" do
    package_name value_for_platform(
      "arch"                       => { "default" => "pdns" },
      ["debian","ubuntu"]          => { "default" => "pdns-backend-pgsql" },
      ["redhat","centos","fedora"] => { "default" => "pdns-backend-postgresql" },
      "default"                    => "pdns-backend-postgresql"
    )
  end
end

case node['platform']
when "arch"
  group node['pdns']['group'] do
    action :create
  end

  user node['pdns']['user'] do
    gid      node['pdns']['group']
    shell    "/bin/false"
    home     "/var/spool/powerdns"
    supports :manage_home => true
    system   true
  end
end

# Location of the pdns.local file.
directory "#{node['pdns']['server']['config-dir']}/pdns.d" do
  owner "root"
  group "root"
  mode  "0700"
  action :create
end

# Creates pdns.local file for the selected backend.
template "#{node['pdns']['server']['config-dir']}/pdns.d/pdns.local" do
  source "pdns.local.erb"
  owner  "root"
  group  "root"
  mode   "0600"
end

# Creates PowerDNS Server configuration file.
template "#{node['pdns']['server']['config-dir']}/pdns.conf" do
  source "pdns.conf.erb"
  owner  "root"
  group  "root"
  mode   "0600"
  notifies :restart, "service[pdns]", :immediately
end

# Loads default schema if it is enabled. See schema in the documentation or in files directory.
load_default_schema
# Loads custom schema that is given by the user.
load_custom_schema

service "pdns" do
  action [:enable, :start]
end
