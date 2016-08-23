if node[:platform_family].include?("rhel")
  package 'bind-utils'
end
include_recipe 'resolver'
