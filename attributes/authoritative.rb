#
# Cookbook Name:: pdns
# Attributes:: authoritative
#
# Copyright 2014, Aetrion, LLC.
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

default['pdns']['authoritative']['config_dir'] = '/etc/powerdns'
default['pdns']['authoritative']['data_dir'] = '/var/lib/pdns'

# For Source based builds
default['pdns']['authoritative']['source']['version'] = '3.4.7'
default['pdns']['authoritative']['source']['url'] = "https://downloads.powerdns.com/releases/pdns-#{node['pdns']['authoritative']['source']['version']}.tar.bz2"
default['pdns']['authoritative']['source']['path'] = '/opt'
default['pdns']['authoritative']['source']['backends'] = %w( gsqlite3 )

# For Packages based builds
default['pdns']['authoritative']['package']['backends'] = %w( gsqlite3 )

default['pdns']['authoritative']['config']['config-dir'] =
  node['pdns']['authoritative']['config_dir']
default['pdns']['authoritative']['config']['allow_recursion'] = [ '127.0.0.1' ]
default['pdns']['authoritative']['config']['daemon'] = true
default['pdns']['authoritative']['config']['disable_axfr'] = true
default['pdns']['authoritative']['config']['guardian'] = true
default['pdns']['authoritative']['config']['setgid'] = node['pdns']['group']
default['pdns']['authoritative']['config']['setuid'] = node['pdns']['user']
default['pdns']['authoritative']['config']['version_string'] = 'powerdns'
default['pdns']['authoritative']['config']['default_ttl'] = '3600'
default['pdns']['authoritative']['config']['launch'] = 'gsqlite3'

# MySQL backend parameters
default['pdns']['authoritative']['gmysql']['gmysql-host'] = '127.0.0.1'
default['pdns']['authoritative']['gmysql']['gmysql-port'] = 3306
default['pdns']['authoritative']['gmysql']['gmysql-user'] = 'mysql_user'
default['pdns']['authoritative']['gmysql']['gmysql-password'] = 'mysql_password'
default['pdns']['authoritative']['gmysql']['gmysql-dbname'] = 'pdns'
default['pdns']['authoritative']['gmysql']['gmysql-dnssec'] = 'no'

# Postgres backend parameters.
default['pdns']['authoritative']['gpgsql']['gpgsql-host'] = '127.0.0.1'
default['pdns']['authoritative']['gpgsql']['gpgsql-port'] = 5432
default['pdns']['authoritative']['gpgsql']['gpgsql-user'] = 'pgsql_user'
default['pdns']['authoritative']['gpgsql']['gpgsql-password'] = 'pgsql_password'
default['pdns']['authoritative']['gpgsql']['gpgsql-dbname'] = 'pdns'
default['pdns']['authoritative']['gpgsql']['gpgsql-dnssec'] = 'no'

# SQLite backend parameters
default['pdns']['authoritative']['gsqlite3']['gsqlite3-database'] =
  node['pdns']['authoritative']['data_dir'] + '/pdns.sqlite3'
default['pdns']['authoritative']['gsqlite3']['gsqlite3-dnssec'] = 'no'

# Pipe backend parameters
#
# Beware: the default pipe-command script comes with the source
# distribution, but is missing from the binary packages.
#
default['pdns']['authoritative']['pipe']['pipe-command'] = 
  "/opt/pdns-#{node['pdns']['authoritative']['source']['version']}" +
  "/modules/pipebackend/backend.pl"
