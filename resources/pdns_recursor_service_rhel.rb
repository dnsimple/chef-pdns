#
# Cookbook Name:: pdns
# Resources:: recursor_install
#
# Copyright 2016, Aetrion, LLC DBA DNSimple
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

resource_name :pdns_recursor_service_rhel

provides :pdns_recursor_service, platform: 'centos' do |node|
  node['platform_version'].to_i >= 6
end

property :instance_name, String, name_property: true

action :enable do
  service 'pdns-recursor' do
    action [:enable, :start]
    pattern 'pdns_recursor'
    supports restart: true, reload: true, 'force-reload': true, 'force-stop':true, status: true
  end
end
