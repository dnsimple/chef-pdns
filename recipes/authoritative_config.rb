#
# Cookbook Name:: pdns
# Recipe:: authoritative_config
#

directory node['pdns']['authoritative']['config_dir'] do
  owner node['pdns']['user']
  group node['pdns']['group']
  mode 0750
end

template "#{node['pdns']['authoritative']['config_dir']}/pdns.conf" do
  source 'authoritative.conf.erb'
  owner node['pdns']['user']
  group node['pdns']['group']
  mode 0640
  notifies :restart, 'service[pdns]'
  variables({ 'config' => pdns_config_hash })
end

# For the sqlite3 backend, we can create a database.
# For other backends, the user will need to create it ahead of time.
if node['pdns']['authoritative']['config']['launch'] == 'gsqlite3'
  include_recipe 'pdns::backend_clients'

  directory node['pdns']['authoritative']['data_dir'] do
    owner node['pdns']['user']
    group node['pdns']['group']
    mode 0755
  end

  cookbook_file "/var/tmp/pdns_schema.sql" do
    source "schema.sql"
  end

  db_path = node['pdns']['authoritative']['gsqlite3']['gsqlite3-database']

  ruby_block "load pdns schema" do
    block do
      require 'sqlite3'
      SQLite3::Database.new(db_path) do |db|
        db.execute_batch(IO.read("/var/tmp/pdns_schema.sql"))
      end
    end
  end

  file db_path do
    owner node['pdns']['user']
    group node['pdns']['group']
    mode 0640
  end
end

service 'pdns' do
  provider Chef::Provider::Service::Init::Debian
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end
