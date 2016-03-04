#
# Cookbook Name:: pdns
# Recipe:: load_schema_pg
#
# Copyright 2015-2016, Aetrion, LLC.
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

include_recipe 'database::postgresql'

postgresql_connection_info = {
  host: '127.0.0.1',
  port: node['postgresql']['config']['port'],
  username: 'postgres',
  password: node['postgresql']['password']['postgres']
}

postgresql_database 'powerdns' do
  connection postgresql_connection_info
  action     :create
end

cookbook_file '/var/tmp/pdns_pg_schema.sql' do
  source 'pg_schema.sql'
end

postgresql_database 'powerdns' do
  connection postgresql_connection_info
  sql { ::File.open('/var/tmp/pdns_pg_schema.sql').read }
  action :query
  not_if 'psql -c "\l" | grep powerdns', user: 'postgres'
end

postgresql_database_user 'pdns' do
  connection postgresql_connection_info
  database_name 'powerdns'
  username 'pdns'
  password 'test'
  action :create
  not_if 'psql -c "\du" | grep pdns', user: 'postgres'
end

postgresql_database 'powerdns_grant' do
  connection postgresql_connection_info
  sql 'GRANT ALL ON ALL TABLES IN SCHEMA public TO pdns;'
  action :query
end
