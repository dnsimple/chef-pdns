def default_run_user
  case os[:family]
  when 'debian'
    'pdns'
  when 'rhel'
    'pdns-recursor'
  end
end
