package 'bind-utils' do
  action :install
  only_if { node['platform_family'] == 'rhel' }
end
