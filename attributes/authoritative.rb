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

default['pdns']['authoritative']['backends'] = %w( bind )
default['pdns']['authoritative']['config']['launch'] = 'bind'

default['pdns']['authoritative']['config']['config_dir'] = '/etc/powerdns'
default['pdns']['authoritative']['config']['setgid'] = 'pdns'
default['pdns']['authoritative']['config']['setuid'] = 'pdns'
default['pdns']['authoritative']['config']['version_string'] = 'powerdns'

default['pdns']['authoritative']['config']['allow_recursion'] = [ '127.0.0.1' ]
default['pdns']['authoritative']['config']['daemon'] = true
default['pdns']['authoritative']['config']['disable_axfr'] = true
default['pdns']['authoritative']['config']['guardian'] = true
default['pdns']['authoritative']['config']['default_ttl'] = '3600'

# This attribute is only required in authoritative package installs
case node['pdns']['build_method']
when 'package'
  default['pdns']['authoritative']['config']['include-dir']='/etc/powerdns/pdns.d'
end
