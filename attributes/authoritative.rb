default['pdns']['server_config_version'] = 3

if node['pdns']['server_config_version'] == 2
  default['pdns']['authoritative']['allow_recursion_override'] = 'off'
  default['pdns']['authoritative']['lazy_recursion'] = true
  default['pdns']['authoritative']['logfile'] = 'pdns.log'
  default['pdns']['authoritative']['skip_cname'] = false
  default['pdns']['authoritative']['use_logfile'] = false
  default['pdns']['authoritative']['wildcards'] = nil
else
  default['pdns']['authoritative']['edns_subnet_option_number'] = 20730
  default['pdns']['authoritative']['edns_subnet_processing'] = false
  default['pdns']['authoritative']['entropy_source'] = '/dev/urandom'
  default['pdns']['authoritative']['experimental_direct_dnskey'] = false
  default['pdns']['authoritative']['experimental_json_interface'] = false
  default['pdns']['authoritative']['experimental_logfile'] = '/var/log/pdns.log'
  default['pdns']['authoritative']['log_dns_queries'] = false
  default['pdns']['authoritative']['lua_prequery_script'] = nil
  default['pdns']['authoritative']['max_cache_entries'] = 1000000
  default['pdns']['authoritative']['max_ent_entries'] = 100000
  default['pdns']['authoritative']['overload_queue_length'] = 0
  default['pdns']['authoritative']['query_local_address6'] = '::'
  default['pdns']['authoritative']['receiver_threads'] = 1
  default['pdns']['authoritative']['retrieval_threads'] = 2
  default['pdns']['authoritative']['server_id'] = nil
  default['pdns']['authoritative']['signing_threads'] = 3
  default['pdns']['authoritative']['slave_renotify'] = false
  default['pdns']['authoritative']['tcp_control_address'] = nil
  default['pdns']['authoritative']['tcp_control_port'] = 53000
  default['pdns']['authoritative']['tcp_control_range'] = [ '127.0.0.0/8',
                                                  '10.0.0.0/8',
                                                  '192.168.0.0/16',
                                                  '172.16.0.0/12',
                                                  '::1/128',
                                                  'fe80::/10' ]
  default['pdns']['authoritative']['tcp_control_secret'] = nil
  default['pdns']['authoritative']['traceback_handler'] = true
end

default['pdns']['authoritative']['allow_axfr_ips'] = [ '0.0.0.0/0',
                                             '::/0' ]
default['pdns']['authoritative']['allow_recursion'] = [ '127.0.0.1' ]
default['pdns']['authoritative']['cache_ttl'] = 20
default['pdns']['authoritative']['chroot'] = nil
default['pdns']['authoritative']['config_dir'] = '/etc/pdns'
default['pdns']['authoritative']['config_name'] = nil
default['pdns']['authoritative']['control_console'] = false
default['pdns']['authoritative']['daemon'] = true
default['pdns']['authoritative']['default_soa_name'] = nil
default['pdns']['authoritative']['default_ttl'] = 3600
default['pdns']['authoritative']['disable_axfr'] = true
default['pdns']['authoritative']['disable_tcp'] = false
default['pdns']['authoritative']['distributor_threads'] = 3
default['pdns']['authoritative']['do_ipv6_additional_processing'] = true
default['pdns']['authoritative']['fancy_records'] = false
default['pdns']['authoritative']['gmysql_host'] = nil
default['pdns']['authoritative']['gmysql_user'] = nil
default['pdns']['authoritative']['gmysql_password'] = nil
default['pdns']['authoritative']['gmysql_dbname'] = nil
default['pdns']['authoritative']['guardian'] = true
default['pdns']['authoritative']['launch'] = nil
default['pdns']['authoritative']['load_modules'] = nil
default['pdns']['authoritative']['local_address'] = node['ipaddress']
default['pdns']['authoritative']['local_ipv6'] = nil
default['pdns']['authoritative']['local_port'] = 53
default['pdns']['authoritative']['log_dns_details'] = false
default['pdns']['authoritative']['log_failed_updates'] = false
default['pdns']['authoritative']['logging_facility'] = nil
default['pdns']['authoritative']['loglevel'] = 4
default['pdns']['authoritative']['master'] = 'off'
default['pdns']['authoritative']['max_queue_length'] = 5000
default['pdns']['authoritative']['max_tcp_connections'] = 10
default['pdns']['authoritative']['module_dir'] = '/usr/lib/pdns'
default['pdns']['authoritative']['negquery_cache_ttl'] = 60
default['pdns']['authoritative']['no_shuffle'] = false
default['pdns']['authoritative']['out_of_zone_additional_processing'] = true
default['pdns']['authoritative']['pipebackend_abi_version'] = 1
default['pdns']['authoritative']['pipe_command'] = nil
default['pdns']['authoritative']['query_cache_ttl'] = 20
default['pdns']['authoritative']['query_local_address'] = '0.0.0.0'
default['pdns']['authoritative']['query_logging'] = false
default['pdns']['authoritative']['queue_limit'] = 1500
default['pdns']['authoritative']['recursive_cache_ttl'] = 10
default['pdns']['authoritative']['recursor'] = false
default['pdns']['authoritative']['send_root_referral'] = false
default['pdns']['authoritative']['setgid'] = 'pdns'
default['pdns']['authoritative']['setuid'] = 'pdns'
default['pdns']['authoritative']['slave'] = 'off'
default['pdns']['authoritative']['slave_cycle_interval'] = 60
default['pdns']['authoritative']['smtpredirector'] = nil
default['pdns']['authoritative']['soa_expire_default'] = 604800
default['pdns']['authoritative']['soa_minimum_ttl'] = 3600
default['pdns']['authoritative']['soa_refresh_default'] = 10800
default['pdns']['authoritative']['soa_retry_default'] = 3600
default['pdns']['authoritative']['soa_serial_offset'] = 0
default['pdns']['authoritative']['socket_dir'] = '/var/run'
default['pdns']['authoritative']['strict_rfc_axfrs'] = false
default['pdns']['authoritative']['trusted_notification_proxy'] = nil
default['pdns']['authoritative']['urlredirector'] = '127.0.0.1'
default['pdns']['authoritative']['version_string'] = 'powerdns'
default['pdns']['authoritative']['webserver'] = false
default['pdns']['authoritative']['webserver_address'] = '127.0.0.1'
default['pdns']['authoritative']['webserver_password'] = nil
default['pdns']['authoritative']['webserver_port'] = 8081
default['pdns']['authoritative']['webserver_print_arguments'] = false
default['pdns']['authoritative']['wildcard_url'] = false
default['pdns']['authoritative']['searchdomains'] = ''
