require 'spec_helper'

describe 'test::recursor' do
  context 'on ubuntu platform' do
    let(:runner) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04',
        step_into: ['pdns_recursor'])
    end

    let(:chef_run) { runner.converge(described_recipe) }
    let(:version) { '3.7.4' }

    # Chef gets node['lsb']['codename'] even if it is not set as an attribute
    it 'adds apt repository' do
      expect(chef_run).to add_apt_repository('powerdns-recursor')
        .with(uri: 'http://repo.powerdns.com/ubuntu', distribution: 'trusty-rec-40')
    end

    it 'creates apt pin for pdns' do
      expect(chef_run).to add_apt_preference('pdns-*')
        .with(pin: 'origin repo.powerdns.com', pin_priority: '600')
    end

    it 'installs pdns package' do
      expect(chef_run).to install_apt_package('pdns-recursor').with(version: version)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
