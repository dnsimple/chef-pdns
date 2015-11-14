class Chef
  class Resource
    class PdnsRecord < Chef::Resource
      def initialize(name, run_context=nil)
        super
        @resource_name = :pdns_record
        @provider = Chef::Provider::PdnsRecord
        @action = :create
        @allowed_actions = [:create, :remove]

        @name = name
        @ttl = 180
        @type = 'A'
      end

      def content(arg=nil)
        set_or_return(:content, arg, :kind_of => String)
      end

      def domain(arg=nil)
        set_or_return(:domain, arg, :kind_of => String)
      end

      def name(arg=nil)
        set_or_return(:name, arg, :kind_of => String)
      end

      def prio(arg=nil)
        set_or_return(:prio, arg, :kind_of => Integer)
      end

      def ttl(arg=nil)
        set_or_return(:ttl, arg, :kind_of => Integer)
      end

      def type(arg=nil)
        # Set a default priority on MX and SRV records.
        if prio.nil? && (arg == 'MX' || arg == 'SRV')
          prio(0)
        end
        set_or_return(:type, arg, :kind_of => String)
      end

      attr_accessor :exists
    end
  end
end

