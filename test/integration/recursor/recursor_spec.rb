def default_recursor_user
  if os[:family] == 'debian'
    return 'pdns'
  elsif os['platform_name'] == 'redhat'
    return  'powerdns-recursor'
  end
end

describe package('pdns-recursor') do
  it { should be_installed }
end

describe port(53) do
  it { should be_listening }
  its('processes') { should include 'pdns_recursor' }
end

describe user(default_recursor_user) do
  it { should exist }
end

describe group(default_recursor_user) do
  it { should exist }
end

describe command('dig @127.0.0.1 dnsimple.com') do
  its('stdout') { should match(/208.93.64.253/) }
end

## TO-DO
## Add a domain to the configuration (probably bind backend or pipe backend and dig for it)
