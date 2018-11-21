apt_update 'RIGHT_MEOW'

postgresql_server_install 'default' do
  version '10'
  action [:install, :create]
end

execute 'setup_postgres_user' do
  command "psql -c \"CREATE ROLE pdns PASSWORD 'wadus' SUPERUSER INHERIT LOGIN;\""
  user 'postgres'
  not_if "psql -c \"SELECT rolname FROM pg_roles WHERE rolname='pdns';\" | grep pdns", user: 'postgres'
end

execute 'setup_postgres_database' do
  command 'psql -c "CREATE DATABASE pdns;"'
  user 'postgres'
  not_if "psql -c \"SELECT datname FROM pg_database WHERE datname='pdns';\" | grep pdns", user: 'postgres'
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

pg_backend_package = value_for_platform_family(
  'rhel' => 'pdns-backend-postgresql',
  'debian' => 'pdns-backend-pgsql'
)

package pg_backend_package

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
