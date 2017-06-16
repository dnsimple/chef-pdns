#
# Cookbook Name:: pdns
# Resources:: pdns_recursor_
#
# Copyright 2017, Aetrion, LLC DBA DNSimple
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include ::Pdns::Helpers

resource_name :pdns_recursor_repo_rhel

provides :pdns_recursor_repo, os: 'linux' do |_node|
  Chef::Platform::ServiceHelpers.service_resource_providers.include?(:redhat)
end

property :instance_name, String, name_property: true
property :baseurl, String, default: ::Pdns::Helpers::REDHAT_URL['rec']['baseurl']
property :gpgkey, String, default: ::Pdns::Helpers::REDHAT_URL['rec']['gpgkey']
property :debug, [TrueClass, FalseClass], default: false
property :baseurl_debug, String, default: ::Pdns::Helpers::REDHAT_URL['rec']['baseurl_debug']

action :create do
  repo_name = repository_name(new_resource.baseurl, new_resource.instance_name)
  yum_repository repo_name do
    description 'PowerDNS repository for PowerDNS Recursor'
    baseurl new_resource.baseurl
    gpgkey new_resource.gpgkey
    priority '90'
    includepkgs 'pdns*'
    action :create
  end

  yum_repository "#{repo_name}-debuginfo" do
    description 'PowerDNS repository for PowerDNS Recursor - debug symbols'
    baseurl new_resource.baseurl_debug
    gpgkey new_resource.gpgkey
    priority '90'
    includepkgs 'pdns*'
    action :create
    only_if { new_resource.debug }
  end
end

action :delete do
  repo_name = repository_name(new_resource.baseurl, new_resource.instance_name)
  yum_repository repo_name do
    action :delete
  end

  yum_repository "#{repo_name}-debuginfo" do
    action :delete
  end
end

action_class.class_eval do
  def whyrun_supported?
    true
  end
end
