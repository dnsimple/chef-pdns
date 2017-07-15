pdns_authoritative_install 'server_01' do
  action :install
end

pdns_authoritative_backend 'postgresql' do
  action :install
end

pdns_authoritative_config 'server_01' do
  action :create
  launch ['gpgsql']
  variables(
    gpgsql_host: '127.0.0.1',
    gpgsql_user: 'pdns',
    gpgsql_port: 5432,
    gpgsql_dbname: 'pdns',
    gpgsql_password: 'wadus'
  )
end

pdns_authoritative_service 'server_01' do
  action [:enable, :start]
end

include_recipe 'postgresql::server'
include_recipe 'postgresql::ruby'

connection_info = { host: '127.0.0.1', username: 'postgres' }

postgresql_database_user 'pdns' do
  connection connection_info
  superuser true
  password 'wadus'
  action :create
end

postgresql_database 'pdns' do
  connection connection_info
  action :create
end

cookbook_file '/var/tmp/schema_postgres.sql' do
  owner 'root'
  group 'root'
  mode 0755
end

execute 'psql -d pdns < /var/tmp/schema_postgres.sql' do
  user 'postgres'
  action :run
  not_if 'psql -t -d pdns -c "SELECT \'public.domains\'::regclass;"', user: 'postgres'
end

add_zone = 'pdnsutil --config-name authoritative_server_01 create-zone example.org ns1.example.org && pdnsutil --config-name authoritative_server_01 add-record example.org smoke A 127.0.0.123'

execute add_zone do
  user 'root'
  not_if 'pdnsutil --config-name authoritative_server_01 list-zone example.org | grep example.org'
  action :run
end
