#
# Cookbook Name:: pdns
# Attributes:: source
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

default['pdns']['source']['path'] = '/opt'

default['pdns']['recursor']['source']['version'] = '3.7.3'
default['pdns']['recursor']['source']['url'] = 'https://downloads.powerdns.com/releases/pdns-recursor-3.7.3.tar.bz2'
default['pdns']['authoritative']['source']['version'] = '3.4.10'
default['pdns']['authoritative']['source']['url'] = 'https://downloads.powerdns.com/releases/pdns-3.4.10.tar.bz2'
