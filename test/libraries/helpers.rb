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
