default[:pdns][:server][:geo_ttl] = 300
default[:pdns][:server][:geo_zone] = 'geo.example.com'
default[:pdns][:server][:geo_soa_values] = nil
default[:pdns][:server][:geo_ns_records] = [ 'ns1.example.com', 'ns2.example.com' ]
default[:pdns][:server][:geo_ip_map_zonefile] = '/var/lib/pdns/countries.dnsbl'
default[:pdns][:server][:geo_maps] = '/var/lib/pdns/geomap'
default[:pdns][:geo][:country_code_server] = 'countries-ns.mdc.dk/zone/zz.countries.nerd.dk.rbldnsd'
default[:pdns][:geo][:databag] = nil
