require 'spec_helper'

describe 'test::recursor_install' do
  context 'on ubuntu platform' do
    let(:ubuntu_runner) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04',
        step_into: ['pdns_recursor'])
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

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'on rhel platform' do
    let(:rhel_runner) do
      ChefSpec::SoloRunner.new(
      platform: 'centos',
      version: '6.8',
      step_into: ['pdns_recursor']) do |node|
        node.automatic['centos-release']['version'] = '6'
      end
    end

    let(:chef_run) { rhel_runner.converge(described_recipe) }
    let(:version) { '4.0.4-1pdns.el6' }

    it 'installs epel-release package' do
      expect(chef_run).to install_yum_package('epel-release')
    end

    it 'adds yum repository powerdns-rec-40' do
      expect(chef_run).to create_yum_repository('powerdns-rec-40')
    end

    it 'adds yum repository powerdns-rec-40-debuginfo' do
      expect(chef_run).to create_yum_repository('powerdns-rec-40-debuginfo')
    end

    it 'installs pdns recursor package' do
      expect(chef_run).to install_yum_package('pdns-recursor').with(version: version)
    end
  end
end
