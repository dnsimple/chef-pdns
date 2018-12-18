# On ubuntu >=18.04 systemd-resolved needs to be disabled and stopped as it port conflicts
service 'systemd-resolved' do
  action [:stop, :disable]
  only_if { node['platform'].include?('ubuntu') && node['platform_version'].to_f >= 18.04 }
end

# Since we remove resolved we need to make our own resolv.conf
file '/etc/resolv.conf' do
  content <<-EOF
nameserver 9.9.9.9
nameserver 2620:fe::9
  EOF
  force_unlink true
  only_if { node['platform'].include?('ubuntu') && node['platform_version'].to_f >= 18.04 }
end
