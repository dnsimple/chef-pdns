#
# Cookbook Name:: pdns
# Recipe:: server
#
# Copyright 2010, Opscode, Inc.
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


if node['pdns']['package']['enable_server_backend']
  include_recipe "pdns::#{node['pdns']['package']['server_backend']}"
end

package "pdns-server"
package "pdns-backend-pgsql"

resolvconf "custom" do
  nameserver "127.0.0.1"
  search node["pdns"]["authoritative"]["searchdomains"]
  head       "# Don't touch this configuration file!"
  base       "# Will be added after nameserver, search, options config items"
  tail       "# This goes to the end of the file."

  # do not touch my interface configuration plz!
  clear_dns_from_interfaces false
end
