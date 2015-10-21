require 'chef/resource'

class Chef
  class Resource
    class PdnsDomain < Chef::Resource
      def initialize(name, run_context=nil)
        super
        @resource_name = :pdns_domain
        @provider = Chef::Provider::PdnsDomain
        @action = :create
        @allowed_actions = [:create]

        @domain = name
        @soa_email = "hostmaster.#{@domain}"
      end

      def domain(arg=nil)
        set_or_return(:domain, arg, :kind_of => String)
      end

      def soa(arg=nil)
        set_or_return(:soa, arg, :kind_of => String)
      end

      def soa_email(arg=nil)
        if !arg.nil? && arg.include?('@')
          username, domain = arg.split('@')
          username = username.gsub('.', '\\.') 
          formatted_email = [username, domain].compact.join('.')
        else
            formatted_email = arg
        end
        set_or_return(:soa_email, formatted_email, :kind_of => String)
      end

      def soa_ip(arg=nil)
        set_or_return(:soa_ip, arg, :kind_of => String)
      end

      attr_accessor :exists
    end
  end
end
