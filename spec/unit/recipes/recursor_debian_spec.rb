require 'spec_helper'

describe 'pdns_test::recursor_install_multi' do
  context 'on ubuntu platform' do
    let(:ubuntu_runner) do
      ChefSpec::SoloRunner.new(
        os: 'linux',
        platform: 'ubuntu',
        version: '14.04',
        step_into: %w(pdns_recursor_install pdns_recursor_config pdns_recursor_service))
    end

    let(:chef_run) { ubuntu_runner.converge(described_recipe) }

    #
    # Tests for the install resource
    #

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
      expect(chef_run).to install_apt_package('pdns-recursor')
    end

    #
    # Tests for the service resource
    #

    it '[sysvinit] creates a specific init script' do
      expect(chef_run).to create_template('/etc/init.d/pdns-recursor_server_01')
    end

    it '[sysvinit] enables and starts pdns_recursor service' do
      expect(chef_run).to enable_service('pdns-recursor_server_01')
      expect(chef_run).to start_service('pdns-recursor_server_01')
    end

    #
    # Tests for the config resource
    #

    it 'creates pdns config directory' do
      expect(chef_run).to create_directory('/etc/powerdns')
        .with(owner: 'root', group: 'root', mode: '0755')
    end

    it 'creates pdns recursor unix user' do
      expect(chef_run).to create_user('pdns')
        .with(home: '/var/spool/powerdns', shell: '/bin/false', system: true)
    end

    it 'creates a pdns recursor unix group' do
      expect(chef_run).to create_group('pdns')
        .with(members: ['pdns'], system: true)
    end

    it 'creates a pdns recursor socket directory' do
      expect(chef_run).to create_directory('/var/run/server_01')
    end

    it 'creates a recursor instance' do
      expect(chef_run).to create_template('/etc/powerdns/recursor-server_01.conf')
        .with(owner: 'root', group: 'root', mode: '0640')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
