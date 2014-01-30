
def whyrun_supported?
  true
end

action :create do
  if @current_resource.exists
    Chef::Log.info "#{ @new_resource } already exists - nothing to do."
  else
    converge_by("Create #{ @new_resource }") do
      create_pdns_record
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::PdnsDnsrecord.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.domain(@new_resource.domain)
  @current_resource.type(@new_resource.type)
  @current_resource.ttl(@new_resource.ttl)
  @current_resource.content(@new_resource.content)

  if dns_record_exists?(@current_resource.name,
                        @current_resource.domain,
                        @current_resource.type)
    Chef::Log.info "record exists"
    @current_resource.exists = true
  else
    Chef::Log.info "record doesn't exist"
    @current_resource.exists = false
  end
end

def lookup_domain(db,domain)
  domains = db.execute("select id from domains where name=?",domain)
  if domains.empty?
    nil
  else
    domains[0][0]
  end
end

def dns_record_exists?(domain,name,type)
  require 'sqlite3'
  rows=nil
  SQLite3::Database.new("/var/lib/pdns/pdns.sqlite3") do |db|
    domain_id = lookup_domain(db,@new_resource.domain)
    if domain_id.nil?
      Chef::Log.info "domain: #{@new_resource.domain} is missing"
    else
      Chef::Log.info "domain: #{@new_resource.domain} exists - checking #{@new_resource.name}"
      rows = db.execute("select id from records where domain_id=? and name=? and type=?",domain_id,@new_resource.name,@new_resource.type)
      Chef::Log.info "rows: #{rows.to_json}"
    end
  end
  Chef::Log.info "exists? #{!(rows.empty?).to_s}"
  !(rows.empty?)
end

def create_pdns_record
  require 'sqlite3'
  SQLite3::Database.new("/var/lib/pdns/pdns.sqlite3") do |db|
    domain_id = lookup_domain(db,@new_resource.domain)
    if domain_id.nil?
      Chef::Log.info "domain: #{@new_resource.domain} is missing"
    else
      Chef::Log.info "domain: #{@new_resource.domain} exists - adding #{@new_resource.name}"
      rows = db.execute("insert into records (domain_id,name,type,content,ttl) values (?,?,?,?,?)",domain_id,@new_resource.name,@new_resource.type,@new_resource.content,@new_resource.ttl)
    end
  end
end
