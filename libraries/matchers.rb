if defined?(ChefSpec)
  def pdns_recursor_install(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_recursor, :install, resource_name)
  end

  def pdns_recursor_config(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_recursor, :config, resource_name)
  end

  def pdns_recursor_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_recursor, :service, resource_name)
  end

  def pdns_recursor_uninstall(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_recursor, :remove, resource_name)
  end
end
