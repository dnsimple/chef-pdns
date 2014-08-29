#
# Cookbook Name:: pdns
# Recipe:: mysql
#
# Copyright (C) 2014 SiruS (https://github.com/podwhitehawk)
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

if node["pdns"]["mysql_backend"]["hostname"] == 'localhost'
  include_recipe "mysql::server"
end
include_recipe "database::mysql"

package "pdns-backend-mysql" do
	action :install
end

# setup mysql connection
mysql_connection_info = {
  :host => node["pdns"]["mysql_backend"]["hostname"],
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

# create db
mysql_database node["pdns"]["mysql_backend"]["dbname"] do
  connection mysql_connection_info
  action :create
end

# Grant all privileges creating user to all tables in db from all hosts
mysql_database_user node["pdns"]["mysql_backend"]["username"] do
  connection mysql_connection_info
  password node["pdns"]["mysql_backend"]["password"]
  database_name node["pdns"]["mysql_backend"]["dbname"]
  host node["pdns"]["mysql_backend"]["hostname"]
  privileges [:all]
  action :grant
end

cookbook_file "powerdns-mysql-db-structure.sql" do
  path "/tmp/powerdns-mysql-db-structure.sql"
  action :create
  notifies :query, "mysql_database[powerdns_import_sql_dump]", :immediately
end

# import from a dump files
mysql_database "powerdns_import_sql_dump" do
  connection mysql_connection_info
  database_name node["pdns"]["mysql_backend"]["dbname"]
  sql { ::File.open("/tmp/powerdns-mysql-db-structure.sql").read }
  action :nothing
end
