require 'spec_helper'

describe 'test::recursor_debian' do
  context 'on ubuntu platform' do
    let(:ubuntu_runner) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04',
        step_into: ['pdns_recursor', 'pdns_recursor_service'])
    end

    let(:chef_run) { ubuntu_runner.converge(described_recipe) }
    let(:version) { '4.0.4-1pdns.trusty' }

    # Chef gets node['lsb']['codename'] even if it is not set as an attribute
    it 'adds apt repository' do
      expect(chef_run).to add_apt_repository('powerdns-recursor')
      .with(uri: 'http://repo.powerdns.com/ubuntu', distribution: 'trusty-rec-40')
    end

    it 'creates apt pin for pdns' do
      expect(chef_run).to add_apt_preference('pdns-*')
      .with(pin: 'origin repo.powerdns.com', pin_priority: '600')
    end

    it 'installs pdns recursor package' do
      expect(chef_run).to install_apt_package('pdns-recursor').with(version: version)
    end

    it 'creates pdns config directory' do
      expect(chef_run).to create_directory('/etc/pdns-recursor')
      .with(owner: 'root', group: 'root', mode: '0755')
    end

    it 'enables pdns_recursor service' do
      expect(chef_run).to enable_service('pdns-recursor').with(pattern: 'pdns_recursor')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end

