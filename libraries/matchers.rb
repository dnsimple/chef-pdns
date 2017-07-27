if defined?(ChefSpec)
  # Recursor

  def install_pdns_recursor_install(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_recursor_install, :install, resource_name)
  end

  def uninstall_pdns_recursor_uninstall(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_recursor, :uninstall, resource_name)
  end

  def create_pdns_recursor_config(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_recursor_config, :create, resource_name)
  end

  def enable_pdns_recursor_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_recursor_service, :enable, resource_name)
  end

  def start_pdns_recursor_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_recursor_service, :start, resource_name)
  end

  def stop_pdns_recursor_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_recursor_service, :stop, resource_name)
  end

  def restart_pdns_recursor_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_recursor_service, :restart, resource_name)
  end

  # Authoritative

  def install_pdns_authoritative_install(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_authoritative_install, :install, resource_name)
  end

  def uninstall_pdns_authoritative_install(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_authoritative_install, :uninstall, resource_name)
  end

  def create_pdns_authoritative_config(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_authoritative_config, :create, resource_name)
  end

  def enable_pdns_authoritative_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_authoritative_service, :enable, resource_name)
  end

  def start_pdns_authoritative_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_authoritative_service, :start, resource_name)
  end

  def stop_pdns_authoritative_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_authoritative_service, :stop, resource_name)
  end

  def restart_pdns_authoritative_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_authoritative_service, :restart, resource_name)
  end
end
