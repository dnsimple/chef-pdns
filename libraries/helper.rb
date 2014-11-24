module Pdns
  # Helper functions
  module Helper
    # Returns true if database schema exist
    #
    # @param [Hash] connection_info
    # @param [String] database
    #
    # @return [TrueClass, FalseClass]
    def schema_exists?(connection_info, database)
      require 'mysql'

      db = ::Mysql.new(
        connection_info[:host],
        connection_info[:username],
        connection_info[:password],
        nil,
        connection_info[:port] || 3306,
        connection_info[:socket] || nil
      )
      db.select_db(database)
      db.list_tables.count != 0
    end
  end
end

Chef::Recipe.send(:include, Pdns::Helper)
Chef::Resource.send(:include, Pdns::Helper)
