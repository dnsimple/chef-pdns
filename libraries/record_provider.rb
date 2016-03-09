require 'chef/provider'
require 'ipaddress'

class Chef
  class Provider
    class PdnsRecord < Chef::Provider
      def whyrun_supported?
        true
      end

      def action_create
        if @current_resource.exists
          Chef::Log.info "#{ @new_resource } already exists - nothing to do."
        else
          converge_by("Create #{ @new_resource }") do
            create_pdns_record
          end
        end
      end

      def load_current_resource
        @current_resource ||= Chef::Resource::PdnsRecord.new(new_resource.name)
        @current_resource.name(new_resource.name)
        @current_resource.domain(new_resource.domain)
        @current_resource.type(new_resource.type)
        @current_resource.ttl(new_resource.ttl)
        @current_resource.content(new_resource.content)
        @current_resource.prio(new_resource.prio)

        if dns_record_exists?(domain: @current_resource.domain,
                              name: @current_resource.name,
                              type: @current_resource.type,
                              content: @current_resource.content)
          Chef::Log.info "record exists"
          @current_resource.exists = true
        else
          Chef::Log.info "record doesn't exist"
          @current_resource.exists = false
        end

        @current_resource
      end

      def create_pdns_record
        domain_id = lookup_domain(@new_resource.domain)
        if(domain_id.nil?)
          raise "Cannot create record in non-existent domain \"#{@new_resource.domain}\""
        end

        # If it's an A/AAAA record, attempt to parse it as an IP address.
        # If it fails with an exception, we don't want to create the record.
        if(@new_resource.type == 'A')
            IPAddress::IPv4.new(@new_resource.content).to_s
        elsif(@new_resource.type == 'AAAA')
            IPAddress::IPv6.new(@new_resource.content).to_s
        end
        
        pdns_database.from(:records).insert(:domain_id => domain_id,
                                            :name => @new_resource.name,
                                            :type => @new_resource.type,
                                            :content => @new_resource.content,
                                            :ttl => @new_resource.ttl,
                                            :prio => @new_resource.prio)
      end

      def dns_record_exists?(options = {})
        domain_id = lookup_domain(options[:domain])
        if domain_id.nil?
          Chef::Log.warn("domain: #{options[:domain]} is missing")
          false
        else
          pdns_database.from(:records).where(:domain_id => domain_id, 
                                             :name => options[:name], 
                                             :type => options[:type],
                                             :content => options[:content]).count > 0
        end
      end

      def lookup_domain(domain_name)
        domains = pdns_database.from(:domains)
        domain_ids = domains.where(:name => domain_name).map(:id)
        if(domain_ids.count > 1) 
          Chef::Log.warn("More than one database entry found for " +
                         domain_name + " !")
        end
        domain_ids.first
      end
    end
  end
end
