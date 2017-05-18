if node[:kernel][:machine] == 'x86_64'
  machine = 'amd64'
else
  machine = 'i386'
end

default[:pdns][:powerdns_com_package][:version] = "3.2-1_#{machine}"
