pdns_user = 'pdns'
pdns_pass = 'pdns_password'
root_pass = 'change me'

node.set['postgresql']['password']['postgres']['password'] = 'change me'

node.set['pdns']['authoritative']['config']['disable_axfr'] = false
node.set['pdns']['authoritative']['package']['backends'] = %w( gpgsql )
node.set['pdns']['authoritative']['config']['launch'] = 'gpgsql'
node.set['pdns']['authoritative']['gpgsql']['gpgsql-user'] = pdns_user
node.set['pdns']['authoritative']['gpgsql']['gpgsql-password'] = pdns_pass

include_recipe 'apt'
mysql_client 'default'
include_recipe 'pdns::backend_clients'

mysql_service 'foo' do
  port '3306'
  version '5.5'
  initial_root_password root_pass
  action :create
  notifies :run, 'execute[install-pdns-schema]'
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

mysql_database_user pdns_user do
  connection mysql_connection_info
  database_name 'pdns'
  host '%'
  privileges [:all]
  action :grant
end

include_recipe 'pdns::authoritative'

# #
# # This schema file works great when installed via the mysql CLI, but
# # it fails when Ruby reads it and feeds via a query resource.  This
# # smells like an escaping problem.
# #
# # For now, the query resource has been replaced with an 'execute'
# # resource that invokes the mysql CLI.
# #
# schema_path = '/usr/share/dbconfig-common/data/pdns-backend-mysql/install/mysql'
# execute 'install-pdns-schema' do
#   command "cat #{schema_path} | " +
#     "perl -nle 's/type=Inno/engine=Inno/g; print' | " +
#     "/usr/bin/mysql -u root " + 
#     "--host=127.0.0.1 " +
#     "--password='#{root_pass}' pdns"
#   action :nothing
#   notifies :reload, 'service[pdns]'
# end
# g

include_recipe 'test::records'
