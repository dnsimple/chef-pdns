include_recipe 'pdns::server'

cookbook_file ::File.join(Chef::Config['file_cache_path'], 'database.sql') do
  source "database.sql"
  owner "root"
  group "root"
  mode "0644"
end

ruby_block "load pdns schema" do
  block do
    require 'sqlite3'
    SQLite3::Database.new('/var/lib/pdns/pdns.sqlite') do |db|
      db.execute('DELETE FROM domains;')
      db.execute('DELETE FROM records;')
      db.execute_batch(IO.read(::File.join(Chef::Config['file_cache_path'], 'database.sql')))
    end
  end
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
