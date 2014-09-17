# Cookbook Name:: pdns
# Recipe:: gmysql

package "pdns-backend-mysql" do
  package_name value_for_platform(
    "arch" => { "default" => "pdns" },
    ["debian","ubuntu"] => { "default" => "pdns-backend-mysql" },
    ["redhat","centos","fedora"] => { "default" => "pdns-backend-mysql" },
    "default" => "pdns-backend-mysql"
  )
end

directory "/var/lib/pdns"

cookbook_file "/var/tmp/mysql_schema.sql" do
  source "mysql_schema.sql"
end

execute "import database" do
      exists = <<-EOH
      mysql --host=#{node['pdns']['mysql']['hostname']} --port=#{node['pdns']['mysql']['port']} -u #{node['pdns']['mysql']['user']} -p#{node['pdns']['mysql']['password']} #{node['pdns']['mysql']['database']} -e 'show tables' | grep -c "records"
      EOH
#      command "mysql --host=#{node['pdns']['mysql']['hostname']} --port=#{node['pdns']['mysql']['port']} -u #{node['pdns']['mysql']['user']} -p#{node['pdns']['mysql']['password']} #{node['pdns']['mysql']['database']}  < /var/tmp/mysql_schema.sql"
      command "mysql --host=#{node['pdns']['mysql']['hostname']} --port=#{node['pdns']['mysql']['port']} -u #{node['pdns']['mysql']['user']} -p#{node['pdns']['mysql']['password']} #{node['pdns']['mysql']['database']}  < /usr/share/dbconfig-common/data/pdns-backend-mysql/install/mysql "
      not_if exists
end

#hotfix for current debian package
link "/usr/lib/powerdns" do 
  to "/usr/lib/x86_64-linux-gnu/pdns"
end

template "/etc/powerdns/pdns.d/pdns.gmysql.conf" do
      source "pdns.gmysql.erb"
      variables ({
      :host => node['pdns']['mysql']['hostname'],
      :port => node['pdns']['mysql']['port'],
      :user => node['pdns']['mysql']['user'],
      :password => node['pdns']['mysql']['password'],
      :database => node['pdns']['mysql']['database']
      })
      owner "pdns"
      group "root"
      mode 00640
      notifies :restart, "service[pdns]", :immediately
end

file "/etc/powerdns/pdns.d/pdns.local.gsqlite3" do
    action :delete
end

file "/etc/powerdns/pdns.d/pdns.simplebind.conf" do
    action :delete
end
