if defined?(ChefSpec)
  def pdns_recursor_install(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_recursor, :install, resource_name)
  end

  def pdns_recursor_remove(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pdns_recursor, :remove, resource_name)
  end
end