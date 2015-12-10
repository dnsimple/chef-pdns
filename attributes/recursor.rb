#
# Cookbook Name:: pdns
# Attributes:: recursor
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

default['pdns']['recursor']['config_dir'] = '/etc/powerdns'

default['pdns']['recursor']['config']['config_dir'] = '/etc/powerdns'
default['pdns']['recursor']['config']['allow_from'] = [
  '127.0.0.0/8',
  '10.0.0.0/8',
  '192.168.0.0/16',
  '172.16.0.0/12',
  '::1/128',
  'e80::/10'
]
default['pdns']['recursor']['config']['auth_zones'] = []
default['pdns']['recursor']['config']['forward_zones'] = []
default['pdns']['recursor']['config']['forward_zones_recurse'] = []
default['pdns']['recursor']['config']['local_address'] = ['127.0.0.1']
default['pdns']['recursor']['config']['local_port'] = '53'
