include_recipe 'build-essential'
include_recipe 'mysql::client'
include_recipe 'git'

package 'libtool'
package 'pkg-config'
package 'libboost-all-dev'
package 'ragel'

package 'libpq-dev'

git '/usr/src/pdns' do
  repository 'https://github.com/PowerDNS/pdns.git'
  reference node[:pdns][:source][:reference]
  action :sync
end

path = '/usr/src/pdns'

user 'pdns'
group 'pdns'

execute 'pdns: bootstrap' do
  command './bootstrap'
  cwd path
  creates '/usr/src/pdns/configure'
end

execute 'pdns: configure' do
  command './configure ' +
    "--with-modules='#{node[:pdns][:source][:backends]}' " +
    '--with-mysql-includes=/usr/include ' +
    '--without-lua'
  cwd path
  creates '/usr/src/pdns/config.h'
end

execute 'pdns: build' do
  command 'make'
  cwd path
  creates '/usr/src/pdns/pdns/pdns_server'
end

execute 'pdns: install' do
  command 'make install'
  cwd path
  creates '/usr/local/sbin/pdns_server'
end

file '/usr/src/pdns/pdns/pdns' do
  owner 'root'
  group 'root'
  mode '0755'
end

execute 'copy pdns init' do
  command 'cp /usr/src/pdns/pdns/pdns /etc/init.d/pdns'
  not_if 'diff /usr/src/pdns/pdns/pdns /etc/init.d/pdns'
end

file '/etc/init.d/pdns' do
  owner 'root'
  group 'root'
  mode '0755'
end

directory '/etc/powerdns' do
  owner 'pdns'
  group 'pdns'
  mode '0755'
end

link '/usr/local/etc/pdns.conf' do
  to '/etc/powerdns/pdns.conf'
end

template '/etc/powerdns/pdns.conf' do
  source 'pdns.conf.erb'
  owner 'pdns'
  group 'pdns'
  mode '0644'
  notifies :restart, 'service[pdns]', :immediately
end

service 'pdns' do
  action [ :enable, :start ]
end
