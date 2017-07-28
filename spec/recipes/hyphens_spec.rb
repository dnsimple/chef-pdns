require 'spec_helper'

describe 'pdns_test::hyphens' do
  let(:runner) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '16.04',
      os: 'linux',
      step_into: %w(pdns_authoritative_config pdns_authoritative_service pdns_recursor_config pdns_recursor_service))
  end

  let(:chef_run) { runner.converge(described_recipe) }

  context('when creating a configuration for an authoritative') do
    it 'returns an exception' do
      expect { chef_run }.to raise_error
    end
  end
end
