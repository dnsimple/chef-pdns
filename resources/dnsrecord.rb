
actions :create
default_action :create
attribute :name, :kind_of => String, :name_attribute => true
attribute :domain, :kind_of => String
attribute :content, :kind_of => String
attribute :ttl, :kind_of => Integer, :default => 180
attribute :type, :kind_of => String, :default => 'A'

attr_accessor :exists
