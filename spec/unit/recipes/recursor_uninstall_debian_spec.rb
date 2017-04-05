require 'spec_helper'

describe 'pdns_test::recursor_uninstall' do
  context 'on ubuntu platform' do
    let(:ubuntu_runner) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04',
        step_into: ['pdns_recursor_install'])
    end

    let(:chef_run) { ubuntu_runner.converge(described_recipe) }
    let(:version) { '4.0.4-1pdns.trusty' }

    it 'removes pdns package' do
      expect(chef_run).to remove_apt_package('pdns-recursor')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
