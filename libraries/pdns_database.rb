require 'chef/provider'

module PdnsDatabase
  def pdns_database
    require 'sequel'
    launch = node['pdns']['authoritative']['config']['launch']
    if launch == 'gmysql'  
      settings = node['pdns']['authoritative']['gmysql']
      Sequel.connect(:adapter => 'mysql2',
                     :user => settings['gmysql-user'],
                     :password => settings['gmysql-password'],
                     :host => settings['gmysql-host'],
                     :port => settings['gmysql-port'],
                     :database => settings['gmysql-dbname'])
    elsif launch == 'gpgsql'
      settings = node['pdns']['authoritative']['gpgsql']
      Sequel.connect(:adapter => 'postgres',
                     :user => settings['gpgsql-user'],
                     :password => settings['gpgsql-password'],
                     :host => settings['gpgsql-host'],
                     :port => settings['gpgsql-port'],
                     :database => settings['gpgsql-dbname'])
    elsif launch == 'gsqlite3'
      settings = node['pdns']['authoritative']['gsqlite3']
      Sequel.connect(:adapter => 'sqlite',
                     :database => settings['gsqlite3-database'])
    elsif launch.nil?
      raise "node[:pdns][:authoritative][:config][:launch] is nil, " +
            "no powerdns backend has been configured!"
    else
      raise "This provider doesn't support the '#{launch}' backend!"
    end
  end
end

Chef::Provider.send(:include, PdnsDatabase)
