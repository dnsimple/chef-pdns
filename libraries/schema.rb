class Chef
  class Recipe
    def load_default_schema
      Log.info "Loads default schema: #{node['pdns']['load_default_schema']}"
      return if node['pdns']['load_default_schema'] == "no"

      cookbook_file "/tmp/pdns_schema.sql" do
        source "schema.#{node['pdns']['server']['backend']}.sql"
      end

      load_schema "/tmp/pdns_schema.sql"
    end

    def load_custom_schema
      Log.info "Loads custom schema: " + (node['pdns']['custom_schema'] ? "yes" : "no")
      return unless node['pdns']['custom_schema']

      cookbook_file "/tmp/pdns_custom_schema.sql" do
        source node['pdns']['custom_schema']
      end

      load_schema "/tmp/pdns_custom_schema.sql"
    end

    def load_schema schema_file
      sql_script = open(schema_file).read
      case node['pdns']['server']['backend']
      when "sqlite"
        include_recipe "sqlite"
        ruby_block "load pdns schema" do
          block do
            require 'sqlite3'
            SQLite3::Database.new("#{node['pdns']['sqlite']['database']}") do |db|
              db.execute sql_script
            end
          end
        end
      when "mysql"
        ruby_block "load pdns schema" do
          block do
            require 'mysql2'
            client = Mysql2::Client.new(  :host     => node['pdns']['mysql']['host'], 
                                          :port     => node['pdns']['mysql']['port'],
                                          :database => node['pdns']['mysql']['database'],
                                          :username => node['pdns']['mysql']['user'],
                                          :password => node['pdns']['mysql']['password']
                                       )
            client.set_server_option Mysql::OPTION_MULTI_STATEMENTS_ON
            client.query sql_script
          end
        end
      when "pgsql"
        ruby_block "load pdns schema" do
          block do
            client = PG.connect( :host     => node['pdns']['pgsql']['host'],
                                 :port     => node['pdns']['pgsql']['port'],
                                 :dbname   => node['pdns']['pgsql']['database'],
                                 :user     => node['pdns']['pgsql']['user'],
                                 :password => node['pdns']['pgsql']['password']
                               )
            client.exec sql_script
          end
        end
      when "oracle"
      end
    end
  end
end
