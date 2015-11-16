pdns_user = 'pdns'
pdns_pass = 'password'
root_pass = 'change me'

node.set['pdns']['authoritative']['config']['disable_axfr'] = false
node.set['pdns']['authoritative']['package']['backends'] = %w( gmysql )
node.set['pdns']['authoritative']['config']['launch'] = 'gmysql'
node.set['pdns']['authoritative']['gmysql']['gmysql-user'] = 'pdns'
node.set['pdns']['authoritative']['gmysql']['gmysql-password'] = 'password'

include_recipe 'apt'
mysql_client 'default'
include_recipe 'pdns::backend_clients'

mysql_service 'foo' do
  port '3306'
  version '5.5'
  initial_root_password root_pass
  action [:create,:start]
end

mysql_connection_info = {:host => '127.0.0.1',
                         :username => 'root',
                         :password => root_pass}

mysql_database 'pdns' do
  connection mysql_connection_info
end

mysql_database_user pdns_user do
  connection mysql_connection_info
  password pdns_pass
  action :create
end

mysql_database_user "grant-pdns-permissions-for-#{pdns_user}" do
  connection mysql_connection_info
  username pdns_user
  database_name 'pdns'
  host '%'
  privileges [:all]
  action :grant
end

include_recipe 'pdns::authoritative'

#
# This schema file works great when installed via the mysql CLI, but
# it fails when Ruby reads and feeds it via a query resource.  This
# smells like an escaping problem.
#
# For now, the query resource has been replaced with an 'execute'
# resource that invokes the mysql CLI.
#
schema_path = '/usr/share/dbconfig-common/data/pdns-backend-mysql/install/mysql'

mysql_command_string =
  "/usr/bin/mysql -u root " + 
  "--host=127.0.0.1 " +
  "--password='#{root_pass}' pdns"

execute 'install-pdns-schema' do
  command "cat #{schema_path} | " +
    "perl -nle 's/type=Inno/engine=Inno/g; print' | " +
    mysql_command_string

  not_if {
    c = Mixlib::ShellOut.new('echo "select id from domains limit 1;" | ' +
                             mysql_command_string)
    c.run_command
    c.status.success?
  }

  sensitive true
      
  notifies :reload, 'service[pdns]'
end

include_recipe 'test::records'
