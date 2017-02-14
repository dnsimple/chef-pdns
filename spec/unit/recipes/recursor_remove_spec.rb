require 'spec_helper'

describe 'test::recursor_remove' do
  context 'on ubuntu platform' do
    let(:runner) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04',
        step_into: ['pdns_recursor'])
    end

    let(:chef_run) { runner.converge(described_recipe) }
    let(:version) { '3.7.4' }

    it 'removes pdns package' do
      expect(chef_run).to remove_apt_package('pdns-recursor').with(version: version)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
