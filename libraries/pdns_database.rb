require 'chef/provider'

module PdnsDatabase
  def pdns_database
    require 'sequel'
    launch = node['pdns']['authoritative']['config']['launch']
    if launch == 'gmysql'  
      settings = node['pdns']['authoritative']['gmysql']
      sequel_url = 'mysql2://' + 
        settings['gmysql-user'] + ':' + settings['gmysql-password'] + '@' + 
        settings['gmysql-host'] + ':' + settings['gmysql-port'].to_s + '/' + 
        settings['gmysql-dbname']
    elsif launch == 'gpgsql'
      settings = node['pdns']['authoritative']['gpgsql']
      sequel_url = 'postgres://' + 
        settings['gpgsql-user'] + ':' + settings['gpgsql-password'] + '@' + 
        settings['gpgsql-host'] + ':' + settings['gpgsql-port'].to_s + '/' + 
        settings['gpgsql-dbname'] 
    elsif launch == 'gsqlite3'
      sequel_url = 'sqlite://' +
        node['pdns']['authoritative']['gsqlite3']['gsqlite3-database']
    elsif launch.nil?
      raise "node[:pdns][:authoritative][:config][:launch] is nil, " +
            "no powerdns backend has been configured!"
    else
      raise "This provider doesn't support the '#{launch}' backend!"
    end
    Sequel.connect(sequel_url)
  end
end

Chef::Provider.send(:include, PdnsDatabase)
