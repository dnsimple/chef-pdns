
actions :create
default_action :create
attribute :domain, :kind_of => String, :name_attribute => true
attribute :soa, :kind_of => String
attribute :soa_ip, :kind_of => String
attribute :soa_email, :kind_of => String

attr_accessor :exists
