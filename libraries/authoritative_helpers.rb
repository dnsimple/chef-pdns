#
# Cookbook Name:: pdns
# Libraries:: authoritive_helpers
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

def default_authoritative_config_directory
  case node['platform_family']
  when 'debian'
    '/etc/powerdns'
  when 'rhel'
    '/etc/pdns'
  end
end

def default_authoritative_run_user
  case node['platform_family']
  when 'debian'
    'pdns'
  when 'rhel'
    'pdns'
  end
end

def backend_package_per_platform
  return 'pdns-backend-geo'      if node['platform_family'] == 'debian' && new_resource.instance_name == 'geo'
  return 'pdns-backend-ldap'     if node['platform_family'] == 'debian' && new_resource.instance_name == 'ldap'
  return 'pdns-backend-mysql '   if node['platform_family'] == 'debian' && new_resource.instance_name == 'mysql'
  return 'pdns-backend-pgsql'    if node['platform_family'] == 'debian' && new_resource.instance_name == 'postgresql'
  return 'pdns-backend-pipe'     if node['platform_family'] == 'debian' && new_resource.instance_name == 'pipe'
  return 'pdns-backend-sqlite3'  if node['platform_family'] == 'debian' && new_resource.instance_name == 'sqlite'
  return 'pdns-backend-geoip'    if node['platform_family'] == 'debian' && new_resource.instance_name == 'geoip'
  return 'pdns-backend-lua'      if node['platform_family'] == 'debian' && new_resource.instance_name == 'lua'
  return 'pdns-backend-mydns'    if node['platform_family'] == 'debian' && new_resource.instance_name == 'mydns'
  return 'pdns-backend-odbc'     if node['platform_family'] == 'debian' && new_resource.instance_name == 'odbc'
  return 'pdns-backend-opendbx'  if node['platform_family'] == 'debian' && new_resource.instance_name == 'opendbx'
  return 'pdns-backend-remote'   if node['platform_family'] == 'debian' && new_resource.instance_name == 'remote'
  return 'pdns-backend-tinydns'  if node['platform_family'] == 'debian' && new_resource.instance_name == 'tinydns'

  return 'pdns-backend-geo'        if node['platform_family'] == 'rhel' && new_resource.instance_name == 'geo'
  return 'pdns-backend-ldap'       if node['platform_family'] == 'rhel' && new_resource.instance_name == 'ldap'
  return 'pdns-backend-lua'        if node['platform_family'] == 'rhel' && new_resource.instance_name == 'lua'
  return 'pdns-backend-mydns'      if node['platform_family'] == 'rhel' && new_resource.instance_name == 'mydns'
  return 'pdns-backend-mysql'      if node['platform_family'] == 'rhel' && new_resource.instance_name == 'mysql'
  return 'pdns-backend-pipe'       if node['platform_family'] == 'rhel' && new_resource.instance_name == 'pipe'
  return 'pdns-backend-postgresql' if node['platform_family'] == 'rhel' && new_resource.instance_name == 'postgresql'
  return 'pdns-backend-remote'     if node['platform_family'] == 'rhel' && new_resource.instance_name == 'remote'
  return 'pdns-backend-sqlite'     if node['platform_family'] == 'rhel' && new_resource.instance_name == 'sqlite'
end