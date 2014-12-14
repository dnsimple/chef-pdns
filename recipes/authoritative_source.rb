#
# Cookbook Name:: pdns
# Recipe:: authoritative
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

include_recipe 'build-essential'

package 'libtool'
package 'pkg-config'
package 'libboost-all-dev'
package 'ragel'
package 'libpq-dev'

execute 'pdns: bootstrap' do
  command './bootstrap && ./bootstrap'
  cwd path
  creates '/usr/src/pdns/configure'
end

execute 'pdns: configure' do
  command './configure ' +
    "--with-modules='#{node['pdns']['source']['backends'].join(' ')}' " +
    "--with-config-dir=#{node['pdns']['source']['config_dir']} " +
    '--with-mysql-includes=/usr/include ' +
    '--without-lua'
  cwd path
  creates '/usr/src/pdns/config.h'
end

execute 'pdns: build' do
  command 'make'
  cwd node['pdns']['source']['path']
  creates '/usr/src/pdns/pdns/pdns_server'
end

execute 'pdns: install' do
  command 'make install'
  cwd node['pdns']['source']['path']
  creates '/usr/local/sbin/pdns_server'
end

file '/usr/src/pdns/pdns/pdns' do
  owner 'root'
  group 'root'
  mode '0755'
end

execute 'copy pdns init' do
  command 'cp /usr/src/pdns/pdns/pdns /etc/init.d/pdns'
  not_if 'diff /usr/src/pdns/pdns/pdns /etc/init.d/pdns'
end

file '/etc/init.d/pdns' do
  owner 'root'
  group 'root'
  mode '0755'
end

directory '/etc/powerdns' do
  owner 'pdns'
  group 'pdns'
  mode '0755'
end

