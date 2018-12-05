pdns_recursor_install 'default'

pdns_recursor_config 'default'

pdns_recursor_config 'server_02' do
  virtual true
  run_user 'another-pdns'
  run_group 'another-pdns'
  run_user_home '/var/lib/another-pdns'
  variables(
    'local-port' => '54'
  )
end

pdns_recursor_service 'default' do
  action [:enable, :start]
end

pdns_recursor_service 'server_02' do
  virtual true
  action [:enable, :start]
end
