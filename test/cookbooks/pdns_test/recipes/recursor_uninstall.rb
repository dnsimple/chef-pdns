pdns_recursor_install 'a_pdns_recursor' do
  action :uninstall
  version recursor_version_per_platform
end