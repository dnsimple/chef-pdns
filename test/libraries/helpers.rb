def default_recursor_run_user
  case os[:family]
  when 'debian'
    'pdns'
  when 'redhat'
    'pdns-recursor'
  end
end

def default_authoritative_run_user
  case os[:family]
  when 'debian'
    'pdns'
  when 'redhat'
    'pdns'
  end
end

def default_authoritative_config_directory
  case os[:family]
  when 'debian'
    '/etc/powerdns'
  when 'redhat'
    '/etc/pdns'
  end
end

def default_authoritative_package
  case os[:family]
  when 'debian'
    'pdns-server'
  when 'redhat'
    'pdns'
  end
end

def default_authoritative_postgres_backend_package
  case os[:family]
  when 'debian'
    'pdns-backend-pgsql'
  when 'redhat'
    'pdns-backend-postgresql'
  end
end

# Code extracted from inspec:
# https://github.com/chef/inspec/blob/master/lib/resources/service.rb#L104
def systemd_is_init?
  platform = os[:name]
  if %w(ubuntu).include?(platform)
    os[:release].to_f >= 15.04
  elsif %w(debian).include?(platform)
    os[:release].to_i > 7
  elsif %w(redhat fedora centos oracle).include?(platform)
    version = os[:release].to_i
    (%w( redhat centos oracle ).include?(platform) && version >= 7) || (platform == 'fedora' && version >= 15)
  else
    false
  end
end

# TODO: remove this method by fixing its call and coming back to regular inspec
def check_process_name(instance_name = 'server01', user_name = 'pdns', type = 'authoritative')
  if systemd_is_init?
    describe processes(instance_name) do
      its('users') { should eq [user_name] }
    end
  else
    instance_name = "#{instance_name}-instance" unless type == 'recursor'
    # Grep cheat feature
    # "ps aux | grep '[f]irefox'" will only match the process
    instance_name[0] = "[#{instance_name[0]}]"
    describe command("ps axo user:32,command | grep '#{instance_name}' | awk '{print $1}'") do
      its('stdout.chomp') { should eq user_name }
    end
  end
end
