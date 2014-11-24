include_recipe 'pdns::server'

mysql_item = encrypted_data_bag_item(node['pdns']['data_bag'], node['pdns']['data_bag_item'])

mysql_connection_info = {
  :host     => 'localhost',
  :username => 'root',
  :password => mysql_item['server_root_password']
}

cookbook_file ::File.join(Chef::Config['file_cache_path'], 'database.sql') do
  source "database.sql"
  owner "root"
  group "root"
  mode "0644"
end

mysql_database mysql_item['db_name'] do
  connection mysql_connection_info
  sql "TRUNCATE TABLE records;"
  action :query
end

mysql_database mysql_item['db_name'] do
  connection mysql_connection_info
  sql "TRUNCATE TABLE domains;"
  action :query
end

mysql_database mysql_item['db_name'] do
  connection mysql_connection_info
  sql { ::File.open(::File.join(Chef::Config['file_cache_path'], 'database.sql')).read }
  action :query
end

file '/etc/resolv.conf' do
  action :create
  owner 'root'
  group 'root'
  mode '0644'
  content "nameserver 127.0.0.1\nnameserver 8.8.8.8"
end

package "bind-utils" do
  action :install
  only_if { platform_family?("rhel") }
end
