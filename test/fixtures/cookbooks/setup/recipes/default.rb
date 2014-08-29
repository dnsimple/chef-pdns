include_recipe "database::mysql"
mysql_connection_info = {
  :host     => 'localhost',
  :username => 'root',
  :password => node['mysql']['server_root_password']
 
}

mysql_database 'pdns' do
    connection mysql_connection_info
      action :create
end

mysql_database_user node['pdns']['mysql']['user'] do
    connection mysql_connection_info
    password node['pdns']['mysql']['password']
    action :create
end

mysql_database_user node['pdns']['mysql']['user'] do
    connection mysql_connection_info
    password node['pdns']['mysql']['password']
    database_name node['pdns']['mysql']['database']
    privileges [:all]
    action :grant
end
