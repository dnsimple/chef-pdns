root_pass = 'youshouldreallychangeme'

pdns_user = 'postgres'
pdns_pass = root_pass

node.set['postgresql']['password']['postgres'] = root_pass
node.set['postgresql']['config']['listen_addresses'] = 'localhost'
node.set['postgresql']['pg_hba'] =
[
 {
  :type => 'local',
  :db => 'all',
  :user => 'postgres',
  :addr => nil,
  :method => 'ident'
 },
 {
  :type => 'host',
  :db => 'all',
  :user => 'all',
  :addr => '127.0.0.1/32',
  :method => 'md5'
 }
]

node.set['pdns']['authoritative']['config']['disable_axfr'] = false
node.set['pdns']['authoritative']['package']['backends'] = %w( gpgsql )
node.set['pdns']['authoritative']['config']['launch'] = 'gpgsql'
node.set['pdns']['authoritative']['gpgsql']['gpgsql-user'] = pdns_user
node.set['pdns']['authoritative']['gpgsql']['gpgsql-password'] = pdns_pass

include_recipe 'apt'
include_recipe 'postgresql::client'
include_recipe 'postgresql::ruby'
include_recipe 'postgresql::server'
include_recipe 'pdns::backend_clients'

postgresql_connection_info = {:host => '127.0.0.1',
                              :username => 'postgres',
                              :password => root_pass}

include_recipe 'pdns::authoritative'

postgresql_database 'pdns' do
  connection postgresql_connection_info
end

schema_path = '/usr/share/dbconfig-common/data/pdns-backend-pgsql/install/pgsql'

postgresql_database 'install-pdns-schema' do
  connection postgresql_connection_info
  database_name 'pdns'
  action :query
  sql lazy { File.read(schema_path) }
  not_if {
    c = Mixlib::ShellOut.new("psql -c 'select id from domains limit 1;' pdns",
                             :user => 'postgres')
    c.run_command
    c.status.success?
  }
end

include_recipe 'test::records'
