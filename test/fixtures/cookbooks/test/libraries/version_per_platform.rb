def version_per_platform
  case node['platform']
  when 'debian'
    '4.0.4-1pdns.jessie'
  when 'ubuntu'
    "4.0.4-1pdns.#{node['lsb']['codename']}"
  when 'centos'
    "4.0.4-1pdns.el#{node['centos-release']['version']}"
  end
end
