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

default['pdns']['authoritative']['allow_recursion'] = [ '127.0.0.1' ]
default['pdns']['authoritative']['config_dir'] = '/etc/powerdns'
default['pdns']['authoritative']['daemon'] = true
default['pdns']['authoritative']['disable_axfr'] = true
default['pdns']['authoritative']['guardian'] = true
default['pdns']['authoritative']['setgid'] = 'pdns'
default['pdns']['authoritative']['setuid'] = 'pdns'
default['pdns']['authoritative']['version_string'] = 'powerdns'

default['pdns']['authoritative']['source']['url'] = 'https://downloads.powerdns.com/releases/pdns-3.4.1.tar.bz2'
default['pdns']['authoritative']['source']['path'] = '/opt'
default['pdns']['authoritative']['source']['backends'] = %w( pipe gpgsql gmysql )

# The backend to launch with the authoritative server
default['pdns']['authoritative']['launch'] = 'gpgsql'
