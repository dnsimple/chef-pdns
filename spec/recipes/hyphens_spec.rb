require 'spec_helper'

describe 'pdns_test::hyphens' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '16.04',
      os: 'linux',
      step_into: ['pdns_authoritative_config']
    ).converge(described_recipe)
  end

  context('when configured with a hyphen in the name') do
    it 'returns an exception' do
      expect {
        chef_run.pdns_authoritative_config('with-hyphen').instance_name
      }.to raise_error(Chef::Exceptions::ValidationFailed)
    end
  end
end
