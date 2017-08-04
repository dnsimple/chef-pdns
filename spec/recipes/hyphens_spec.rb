require 'spec_helper'

describe 'pdns_test::hyphens' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '16.04',
      os: 'linux'
    ).converge(described_recipe)
  end

  context('pdns_authoritative_config') do
    it 'raises an exception for a hyphen in the name' do
      expect do
        chef_run.pdns_authoritative_config('with-hyphen').instance_name
      end.to raise_error(Chef::Exceptions::ValidationFailed)
    end
  end

  context('pdns_authoritative_service') do
    it 'raises an exception for a hyphen in the name' do
      expect do
        chef_run.pdns_authoritative_service('with-hyphen').instance_name
      end.to raise_error(Chef::Exceptions::ValidationFailed)
    end
  end

  context('pdns_recursor_config') do
    it 'raises an exception for a hyphen in the name' do
      expect do
        chef_run.pdns_recursor_config('with-hyphen').instance_name
      end.to raise_error(Chef::Exceptions::ValidationFailed)
    end
  end

  context('pdns_recursor_service') do
    it 'raises an exception for a hyphen in the name' do
      expect do
        chef_run.pdns_recursor_service('with-hyphen').instance_name
      end.to raise_error(Chef::Exceptions::ValidationFailed)
    end
  end
end
