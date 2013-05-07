# don't use this recipe directly!
# set node[:pdns][:server][:launch] = 'geo'
# set node[:pdns][:server][:server_backend] = 'geo'
#    or
# set node[:pdns][:server][:launch] = ['geo', 'sqlite']
# set node[:pdns][:server][:server_backend] = ['geo', 'sqlite]

directory node[:pdns][:server][:geo_maps] do
    action :create
    owner "root"
    group "root"
    mode 00755
end

#  Create and populate the geo maps if a databag is defined
data_bag(node[:pdns][:geo][:databag]).each do |geomap|
    template "#{node[:pdns][:server][:geo_maps]}/#{geomap}" do
        source "geomap.erb"
        variables(
            :geomap => data_bag_item(node[:pdns][:geo][:databag], geomap)
        )
        mode 0644
        owner "root"
        group "pdns"
        action :create
    end
end

package "rsync"
package "pdns-backend-geo"

cron "pdns_regionmap" do
    minute "0"
    hour "0"
    user "root"
    command %Q{rsync -aq rsync://#{node[:pdns][:geo][:country_code_server]} #{node[:pdns][:server][:geo_ip_map_zonefile]}}
end

bash "create_country_file" do
    action :run
    creates node[:pdns][:server][:geo_ip_map_zonefile]
    user "root"
    code <<-EOS
        rsync -aq rsync://#{node[:pdns][:geo][:country_code_server]} #{node[:pdns][:server][:geo_ip_map_zonefile]}
    EOS
end



#  These are required to make pdns geo backend work properly
#  don't include geo as a backend service if your dns farm
#  can't handle the additional load or use a seperate role
node.force_override[:pdns][:server][:query_cache_ttl] = 0
node.force_override[:pdns][:server][:cache_ttl] = 0
node.force_override[:pdns][:server][:distributor_threads] = 1
