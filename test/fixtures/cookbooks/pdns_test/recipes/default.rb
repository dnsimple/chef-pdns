# places the test backend file

cookbook_file '/tmp/backend.pl' do
    source 'backend.pl'
    owner node['pdns']['user']
    group node['pdns']['user']
    mode 00755
end
