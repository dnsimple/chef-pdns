#
# Cookbook Name:: pdns
# Libraries:: helpers
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

def pdns_pathname(uri)
  require 'pathname'
  require 'uri'
  Pathname.new(URI.parse(uri).path)
end

def pdns_file(uri)
  pdns_pathname(uri).basename.to_s
end

def pdns_dir(uri)
  path = pdns_pathname(uri)
  extension = '.tar.bz2'
  filename = path.basename.to_s
  base_path = node['pdns']['authoritative']['source']['path']
  "#{base_path}/#{::File.basename(filename, extension)}"
end

# Packaged distributions still require development libraries so that Chef
# can build gems for providers to access the PDNS database.
def pdns_package_module_requirements
  modules = node['pdns']['authoritative']['package']['backends']
  required_packages = []
  modules.each do |mod|
    case mod
    when 'gmysql'
      required_packages << 'pdns-backend-mysql'
    when 'gpgsql'
      required_packages << 'pdns-backend-pgsql'
    when 'gsqlite3'
      required_packages << 'pdns-backend-sqlite3'
      required_packages << 'sqlite3'
    when 'pipe'
      required_packages << 'pdns-backend-pipe'
    end
  end
  required_packages
end

def pdns_source_module_requirements
  modules = node['pdns']['authoritative']['source']['backends']
  required_packages = []
  modules.each do |mod|
    case mod
    when 'gmysql'
      required_packages << 'libmysqlclient-dev'
    when 'gpgsql'
      required_packages << 'libpq-dev'
    when 'gsqlite3'
      required_packages << 'libsqlite3-dev'
    end
  end
  required_packages
end

def pdns_config_hash
  base_config = node['pdns']['authoritative']['config']
  launch = node['pdns']['authoritative']['config']['launch']
  backend_config = node['pdns']['authoritative'][launch] rescue {}
  return base_config.merge(backend_config)
end
