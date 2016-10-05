# places the test backend file

cookbook_file '/var/tmp/backend.pl' do
  source 'backend.pl'
  owner 'root'
  group 'root'
  mode 00755
end
