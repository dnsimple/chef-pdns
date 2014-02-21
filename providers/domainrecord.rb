
def whyrun_supported?
  true
end

action :create do
  if @current_resource.exists
    Chef::Log.info "#{ @new_resource } already exists - nothing to do."
  else
    converge_by("Create #{ @new_resource }") do
      create_pdns_domain_record
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::PdnsDnsrecord.new(@new_resource.domain)
  @current_resource.domain(@new_resource.domain)
  
  if domain_exists?(@current_resource.domain)
    @current_resource.exists = true
  end
end

def domain_exists?(domain)
  require 'sqlite3'
  rows=nil
  SQLite3::Database.new("/var/lib/pdns/pdns.sqlite3") do |db|
    rows = db.execute("select * from domains where name=?",domain)
  end
  !(rows.empty?)
end

def lookup_domain(db,domain)
  domains = db.execute("select id from domains where name=?",domain)
  if domains.empty?
    nil
  else
    Chef::Log.info(domains.to_json)
    domains[0][0]
  end
end


def create_pdns_domain_record
  require 'sqlite3'
  SQLite3::Database.new("/var/lib/pdns/pdns.sqlite3") do |db|
    rows = db.execute("insert into domains (name,type) values (?,'NATIVE')",@new_resource.domain)
    domain_id = lookup_domain(db,@new_resource.domain)
    
    rows = db.execute("insert into records (domain_id,name,type,content,ttl) values (?,?,?,?,?)",
                      domain_id,
                      @new_resource.domain,
                      "SOA",
                      "ns1.#{@new_resource.domain}. #{@new_resource.soa_email}. 1 10800 3600 604800 3600",
                      "86400")
    rows = db.execute("insert into records (domain_id,name,type,content,ttl) values (?,?,?,?,?)",
                      domain_id,
                      @new_resource.domain,
                      "NS",
                      "ns1.#{@new_resource.domain}",
                      "86400")
    rows = db.execute("insert into records (domain_id,name,type,content,ttl) values (?,?,?,?,?)",
                      domain_id,
                      "ns1.#{@new_resource.domain}",
                      "A",
                      @new_resource.soa_ip,
                      "120")
  end
end
