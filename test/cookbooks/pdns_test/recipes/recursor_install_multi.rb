pdns_recursor_install 'default' do
  debug true
end

pdns_recursor_config 'default'

pdns_recursor_config 'server_02' do
  virtual true
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
