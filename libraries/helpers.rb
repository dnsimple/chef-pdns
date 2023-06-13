#
# Cookbook:: pdns
# Libraries:: helpers
#
# # Copyright:: 2023, DNSimple Corp.
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
module Pdns
  # Common helper for PowerDNS cookbook
  module Helpers
    def default_user_attributes
      case node['platform_family']
      when 'debian'
        Mash.new(home: '/var/spool/powerdns', shell: '/bin/false')
      when 'rhel'
        Mash.new(home: '/', shell: '/sbin/nologin')
      end
    end
  end

  # Helpers method for recursor feature
  module RecursorHelpers
    include Pdns::Helpers

    def systemd_name(name, virtual)
      virtual ? "pdns-recursor@#{name}.service" : 'pdns-recursor.service'
    end

    def default_recursor_run_user
      case node['platform_family']
      when 'debian'
        'pdns'
      when 'rhel'
        'pdns-recursor'
      end
    end

    def default_recursor_config_directory
      case node['platform_family']
      when 'debian'
        '/etc/powerdns'
      when 'rhel'
        '/etc/pdns-recursor'
      end
    end

    def recursor_socket_directory(name, socket_dir, virtual)
      virtual ? "/var/run/pdns-recursor-#{name}" : socket_dir
    end

    def recursor_instance_config(name, virtual)
      virtual ? "recursor-#{name}.conf" : 'recursor.conf'
    end
  end

  # Helpers method for authoritative feature
  module AuthoritativeHelpers
    include Pdns::Helpers

    def systemd_name(name, virtual)
      virtual ? "pdns@#{name}.service" : 'pdns.service'
    end

    def authoritative_instance_config(name, virtual)
      virtual ? "pdns-#{name}.conf" : 'pdns.conf'
    end

    def default_authoritative_run_user
      'pdns'
    end

    def default_authoritative_config_directory
      case node['platform_family']
      when 'debian'
        '/etc/powerdns'
      when 'rhel'
        '/etc/pdns'
      end
    end
  end
end
