require 'chef/provider'

class Chef
  class Provider
    class PdnsDomain < Chef::Provider
      def whyrun_supported?
        true
      end

      def action_create
        if @current_resource.exists
          Chef::Log.info "#{ @new_resource } already exists - nothing to do."
        else
          converge_by("Create #{ @new_resource }") do
            create_pdns_domain_record
          end
        end
      end

      def load_current_resource
        @current_resource = Chef::Resource::PdnsRecord.new(@new_resource.domain)
        @current_resource.domain(@new_resource.domain)
        
        if domain_exists?(@current_resource.domain)
          @current_resource.exists = true
        end

        @current_resource
      end

      def create_pdns_domain_record
        pdns_database.from(:domains).insert(:name => @new_resource.domain,
                                       :type => 'NATIVE')
        domain_id = lookup_domain(@new_resource.domain)
        raise "No domain ID found for #{@new_resource.domain}!" if domain_id.nil?

        records = pdns_database.from(:records)

        soa_content = 
          "ns1.#{@new_resource.domain}. #{@new_resource.soa_email}. " +
          "1 10800 3600 604800 3600"
        records.insert(:domain_id => domain_id,
                       :name => @new_resource.domain,
                       :type => 'SOA',
                       :content => soa_content,
                       :ttl => 86400)

        records.insert(:domain_id => domain_id,
                       :name => @new_resource.domain,
                       :type => 'NS',
                       :content => "ns1.#{@new_resource.domain}",
                       :ttl => 86400)
        
        records.insert(:domain_id => domain_id,
                       :name =>  "ns1.#{@new_resource.domain}",
                       :type => 'A',
                       :content => @new_resource.soa_ip,
                       :ttl => 120)
      end

      def domain_exists?(domain_name)
        pdns_database.from(:domains).where(:name => domain_name).count > 0
      end

      def lookup_domain(domain_name)
        domains = pdns_database.from(:domains)
        domain_ids = domains.where(:name => domain_name).map(:id)
        if(domain_ids.count > 1) 
          Chef::Log.warn("More than one domain ID found for \"#{domain_name}\" !")
        end
        domain_ids.first
      end
    end
  end
end
