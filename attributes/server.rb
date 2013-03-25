default[:pdns][:server_config_version] = 3

if node[:pdns][:server_config_version] == 2
  default[:pdns][:server][:allow_recursion_override] = 'off'
  default[:pdns][:server][:lazy_recursion] = true
  default[:pdns][:server][:logfile] = 'pdns.log'
  default[:pdns][:server][:skip_cname] = false
  default[:pdns][:server][:use_logfile] = false
  default[:pdns][:server][:wildcards] = nil
else
  default[:pdns][:server][:edns_subnet_option_number] = 20730
  default[:pdns][:server][:edns_subnet_processing] = false
  default[:pdns][:server][:entropy_source] = '/dev/urandom'
  default[:pdns][:server][:experimental_direct_dnskey] = false
  default[:pdns][:server][:experimental_json_interface] = false
  default[:pdns][:server][:experimental_logfile] = '/var/log/pdns.log'
  default[:pdns][:server][:log_dns_queries] = false
  default[:pdns][:server][:lua_prequery_script] = nil
  default[:pdns][:server][:max_cache_entries] = 1000000
  default[:pdns][:server][:max_ent_entries] = 100000
  default[:pdns][:server][:overload_queue_length] = 0
  default[:pdns][:server][:query_local_address6] = '::'
  default[:pdns][:server][:receiver_threads] = 1
  default[:pdns][:server][:retrieval_threads] = 2
  default[:pdns][:server][:server_id] = nil
  default[:pdns][:server][:signing_threads] = 3
  default[:pdns][:server][:slave_renotify] = false
  default[:pdns][:server][:tcp_control_address] = nil
  default[:pdns][:server][:tcp_control_port] = 53000
  default[:pdns][:server][:tcp_control_range] = [ '127.0.0.0/8',
                                                  '10.0.0.0/8',
                                                  '192.168.0.0/16',
                                                  '172.16.0.0/12',
                                                  '::1/128',
                                                  'fe80::/10' ]
  default[:pdns][:server][:tcp_control_secret] = nil
  default[:pdns][:server][:traceback_handler] = true
end

default[:pdns][:server][:allow_axfr_ips] = [ '0.0.0.0/0',
                                             '::/0' ]
default[:pdns][:server][:allow_recursion] = [ '127.0.0.1' ]
default[:pdns][:server][:cache_ttl] = 20
default[:pdns][:server][:chroot] = nil
default[:pdns][:server][:config_dir] = '/etc/pdns'
default[:pdns][:server][:config_name] = nil
default[:pdns][:server][:control_console] = false
default[:pdns][:server][:daemon] = true
default[:pdns][:server][:default_soa_name] = nil
default[:pdns][:server][:default_ttl] = 3600
default[:pdns][:server][:disable_axfr] = true
default[:pdns][:server][:disable_tcp] = false
default[:pdns][:server][:distributor_threads] = 3
default[:pdns][:server][:do_ipv6_additional_processing] = true
default[:pdns][:server][:fancy_records] = false
default[:pdns][:server][:gmysql_host] = nil
default[:pdns][:server][:gmysql_user] = nil
default[:pdns][:server][:gmysql_password] = nil
default[:pdns][:server][:gmysql_dbname] = nil
default[:pdns][:server][:guardian] = true
default[:pdns][:server][:launch] = nil
default[:pdns][:server][:load_modules] = nil
default[:pdns][:server][:local_address] = node[:ipaddress]
default[:pdns][:server][:local_ipv6] = nil
default[:pdns][:server][:local_port] = 53
default[:pdns][:server][:log_dns_details] = false
default[:pdns][:server][:log_failed_updates] = false
default[:pdns][:server][:logging_facility] = nil
default[:pdns][:server][:loglevel] = 4
default[:pdns][:server][:master] = 'off'
default[:pdns][:server][:max_queue_length] = 5000
default[:pdns][:server][:max_tcp_connections] = 10
default[:pdns][:server][:module_dir] = '/usr/lib/pdns'
default[:pdns][:server][:negquery_cache_ttl] = 60
default[:pdns][:server][:no_shuffle] = false
default[:pdns][:server][:out_of_zone_additional_processing] = true
default[:pdns][:server][:pipebackend_abi_version] = 1
default[:pdns][:server][:pipe_command] = nil
default[:pdns][:server][:query_cache_ttl] = 20
default[:pdns][:server][:query_local_address] = '0.0.0.0'
default[:pdns][:server][:query_logging] = false
default[:pdns][:server][:queue_limit] = 1500
default[:pdns][:server][:recursive_cache_ttl] = 10
default[:pdns][:server][:recursor] = false
default[:pdns][:server][:send_root_referral] = false
default[:pdns][:server][:setgid] = 'pdns'
default[:pdns][:server][:setuid] = 'pdns'
default[:pdns][:server][:slave] = 'off'
default[:pdns][:server][:slave_cycle_interval] = 60
default[:pdns][:server][:smtpredirector] = nil
default[:pdns][:server][:soa_expire_default] = 604800
default[:pdns][:server][:soa_minimum_ttl] = 3600
default[:pdns][:server][:soa_refresh_default] = 10800
default[:pdns][:server][:soa_retry_default] = 3600
default[:pdns][:server][:soa_serial_offset] = 0
default[:pdns][:server][:socket_dir] = '/var/run'
default[:pdns][:server][:strict_rfc_axfrs] = false
default[:pdns][:server][:trusted_notification_proxy] = nil
default[:pdns][:server][:urlredirector] = '127.0.0.1'
default[:pdns][:server][:version_string] = 'powerdns'
default[:pdns][:server][:webserver] = false
default[:pdns][:server][:webserver_address] = '127.0.0.1'
default[:pdns][:server][:webserver_password] = nil
default[:pdns][:server][:webserver_port] = 8081
default[:pdns][:server][:webserver_print_arguments] = false
default[:pdns][:server][:wildcard_url] = false
