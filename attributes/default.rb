#
# Cookbook Name:: pdns
# Attributes:: default
#
# Copyright 2010, Opscode, Inc.
# Copyright 2013, Gabor Nagy
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

default['pdns']['user']  = "pdns"
default['pdns']['group'] = "pdns"

case platform
when "redhat","centos","fedora","scientific","oracle","amazon"
  arch = node['kernel']['machine'] =~ /x86_64/ ? "64" : nil

  default['pdns']['server']['config-dir']    = "/etc/pdns"
  default['pdns']['server']['module-dir']    = "/usr/lib#{arch}/pdns"
  default['pdns']['recursor']['config-dir']  = "/etc/pdns-recursor"
  default['pdns']['user']                    = "pdns-recursor"
  default['pdns']['group']                   = "pdns-recursor"
else
  default['pdns']['server']['config-dir']    = "/etc/powerdns"
  default['pdns']['server']['module-dir']    = "/usr/lib/powerdns"
  default['pdns']['recursor']['config-dir']  = "/etc/powerdns"
end

default['pdns']['server']['backend']         = "sqlite"
default['pdns']['load_default_schema']       = "no"
default['pdns']['custom_schema']             = nil
default['pdns']['sqlite']['database']        = "#{node['pdns']['server']['config-dir']}/pdns.sqlite"
default['pdns']['sqlite']['queries']         = {}
default['pdns']['mysql']['host']             = nil
default['pdns']['mysql']['port']             = "3306"
default['pdns']['mysql']['database']         = nil
default['pdns']['mysql']['user']             = nil
default['pdns']['mysql']['password']         = nil
default['pdns']['mysql']['queries']          = {}
default['pdns']['pgsql']['host']             = nil
default['pdns']['pgsql']['port']             = "5432"
default['pdns']['pgsql']['database']         = nil
default['pdns']['pgsql']['user']             = nil
default['pdns']['pgsql']['password']         = nil
default['pdns']['pgsql']['queries']          = {}

locals = [
  "127.0.0.0/8",
  "10.0.0.0/8",
  "192.168.0.0/16",
  "172.16.0.0/12",
  "::1/128",
  "e80::/10"
]

# Settings for the PowerDNS server.
default['pdns']['server']['local-address']                = ['0.0.0.0']
default['pdns']['server']['local-port']                   = "53"
default['pdns']['server']['local-ipv6']                   = []
default['pdns']['server']['allow-axfr-ips']               = []
default['pdns']['server']['disable-axfr']                 = "yes"
default['pdns']['server']['allow-recursion']              = locals
default['pdns']['server']['allow-recursion-override']     = nil
default['pdns']['server']['cache-ttl']                    = "120"
default['pdns']['server']['recursor']                     = nil
default['pdns']['server']['chroot']                       = nil
default['pdns']['server']['daemon']                       = "yes"
default['pdns']['server']['default-soa-name']             = nil
default['pdns']['server']['guardian']                     = "yes"
default['pdns']['server']['lazy-recursion']               = "yes"
default['pdns']['server']['log-failed-updates']           = nil # "/var/log/pdns/failed-updates.log"
default['pdns']['server']['logfile']                      = nil # "/var/log/pdns/pdns.log"
default['pdns']['server']['logging-facility']             = nil
default['pdns']['server']['loglevel']                     = nil # "4"
default['pdns']['server']['master']                       = nil # "yes"
default['pdns']['server']['max-queue-length']             = nil
default['pdns']['server']['max-tcp-connections']          = nil
default['pdns']['server']['query-logging']                = "no"
default['pdns']['server']['skip-cname']                   = nil # no
default['pdns']['server']['slave']                        = nil # "no"
default['pdns']['server']['slave-cycle-interval']         = nil # "60"
default['pdns']['server']['smtpredirector']               = nil
default['pdns']['server']['soa-minimum-ttl']              = nil # "600"
default['pdns']['server']['soa-refresh-default']          = nil # "10800"
default['pdns']['server']['soa-retry-default']            = nil # "3600"
default['pdns']['server']['soa-expire-default']           = nil # "604800"
default['pdns']['server']['soa-serial-offset']            = nil # "0"
default['pdns']['server']['socket-dir']                   = nil # "/var/run"
default['pdns']['server']['use-logfile']                  = "no"
default['pdns']['server']['webserver']                    = nil # "no"
default['pdns']['server']['webserver-address']            = []
default['pdns']['server']['webserver-password']           = nil
default['pdns']['server']['webserver-port']               = nil # "8081"
default['pdns']['server']['webserver-print-arguments']    = nil # "no"
default['pdns']['server']['wildcard-url']                 = nil # "no"
default['pdns']['server']['wildcards']                    = "no"
default['pdns']['server']['version-string']               = nil # "PowerDNS Server 3.1.5 $Id: pdns_server.cc 1170 2008-03-22 20:43:44Z ahu $"

# Settings for the PowerDNS recursor.
default['pdns']['recursor']['aaaa-additional-processing'] = nil
default['pdns']['recursor']['allow-from']                 = locals
default['pdns']['recursor']['allow-from-file']            = nil
default['pdns']['recursor']['auth-can-lower-ttl']         = nil
default['pdns']['recursor']['auth-zones']                 = []
default['pdns']['recursor']['chroot']                     = nil
default['pdns']['recursor']['client-tcp-timeout']         = "2"
default['pdns']['recursor']['daemon']                     = "yes"
default['pdns']['recursor']['delegation-only']            = []
default['pdns']['recursor']['dont-query']                 = []
default['pdns']['recursor']['entropy-source']             = nil # /dev/urandom
default['pdns']['recursor']['export-etc-hosts']           = nil # off
default['pdns']['recursor']['fork']                       = nil # no
default['pdns']['recursor']['forward-zones']              = []
default['pdns']['recursor']['forward-zones-file']         = nil
default['pdns']['recursor']['hint-file']                  = nil
default['pdns']['recursor']['ignore-rd-bit']              = nil # off
default['pdns']['recursor']['local-address']              = [ipaddress]
default['pdns']['recursor']['local-port']                 = "53"
default['pdns']['recursor']['log-common-errors']          = nil # yes
default['pdns']['recursor']['logging-facility']           = nil
default['pdns']['recursor']['max-cache-entries']          = nil
default['pdns']['recursor']['max-negative-ttl']           = nil # 3600
default['pdns']['recursor']['max-tcp-clients']            = nil # 128
default['pdns']['recursor']['max-tcp-per-client']         = nil
default['pdns']['recursor']['no-shuffle']                 = nil # off
default['pdns']['recursor']['query-local-address']        = nil # 0.0.0.0
default['pdns']['recursor']['query-local-address6']       = nil
default['pdns']['recursor']['quiet']                      = "yes"
default['pdns']['recursor']['remotes-ringbuffer-entries'] = nil # 0
default['pdns']['recursor']['serve-rfc1918']              = nil
default['pdns']['recursor']['server-id']                  = nil
default['pdns']['recursor']['single-socket']              = nil # off
default['pdns']['recursor']['soa-minimum-ttl']            = nil # 0
default['pdns']['recursor']['soa-serial-offset']          = nil # 0
default['pdns']['recursor']['socket-dir']                 = nil # /var/run
default['pdns']['recursor']['spoof-nearmiss-max']         = nil # 20
default['pdns']['recursor']['stack-size']                 = nil # 200000
default['pdns']['recursor']['trace']                      = nil # off
default['pdns']['recursor']['version-string']             = nil # "PowerDNS Recursor 3.1.5 $Id: pdns_recursor.cc 1170 2008-03-22 20:43:44Z ahu $"
default['pdns']['recursor']['forward-zones-recurse']      = []
