
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
  not_if 'psql -t -d pdns -c "select \'public.domains\'::regclass;"', user: 'postgres'
end

pdns_authoritative_install '' do
  action :install
end

pdns_authoritative_backend 'postgresql' do
  action :install
end

pdns_authoritative_config '' do
  action :create
  launch ['gpgsql']
  variables(
    gpgsql_host: '127.0.0.1',
    gpgsql_user: 'pdns',
    gpgsql_port: 5432,
    gpgsql_dbname: 'pdns',
    gpgsql_password: 'wadus'
  )
  notifies :restart, 'pdns_authoritative_service[]'
end

pdns_authoritative_service '' do
  action [:enable, :start]
end

execute 'create_zone' do
  user 'root'
  command 'pdnsutil create-zone example.org ns1.example.org'
  not_if 'pdnsutil list-zone example.org | grep example.org'
end

execute 'add_record' do
  command 'pdnsutil add-record example.org smoke A 127.0.0.123'
  user 'root'
  not_if 'pdnsutil list-zone example.org | grep smoke.example.org'
end
