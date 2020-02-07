package 'bind-utils' do
  action :install
  only_if { platform_family?('rhel') }
end
