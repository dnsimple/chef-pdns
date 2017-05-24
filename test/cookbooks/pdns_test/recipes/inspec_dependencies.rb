package 'lsof' do
  action :install
end

package 'bind-utils' do
  action :install
  only_if { node['platform_family'] == 'rhel' }
end

package 'net-tools' do
  action :install
  only_if { node['platform_family'] == 'debian' }
end

package 'dnsutils' do
  action :install
  only_if { node['platform_family'] == 'debian' }
end
