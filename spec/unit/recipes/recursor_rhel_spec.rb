require 'spec_helper'

describe 'pdns_test::recursor_install_multi' do
  context 'on rhel platform' do
    let(:rhel_runner) do
      ChefSpec::SoloRunner.new(
        platform: 'centos',
        version: '6.8',
        step_into: ['pdns_recursor_install', 'pdns_recursor_config', 'pdns_recursor_service']) do |node|
        node.automatic['packages']['centos-release']['version'] = '6'
      end
    end

    let(:chef_run) { rhel_runner.converge(described_recipe) }
    let(:version) { '4.0.5-1pdns.el6' }

    #
    # Tests for the install resource
    #

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

    #
    # Tests for the service resource
    #

    it 'creates a specific init script (SysVinit)' do
      mock_service_resource_providers(%i{redhat upstart})
      expect(chef_run).to create_template('/etc/init.d/pdns-recursor_server_01')
    end

    it 'enables and starts pdns_recursor service (SysVinit)' do
      mock_service_resource_providers(%i{redhat upstart})
      expect(chef_run).to enable_service('pdns-recursor_server_01')
      expect(chef_run).to start_service('pdns-recursor_server_01')
    end

    it 'should not creates a specific init script (Systemd)' do
      mock_service_resource_providers(%i{redhat systemd})
      expect(chef_run).not_to create_template('/etc/init.d/pdns-recursor_server_01')
    end

    it 'enables and starts pdns_recursor instance (Systemd)' do
      mock_service_resource_providers(%i{redhat systemd})
      expect(chef_run).to enable_service('pdns-recursor@server_01')
      expect(chef_run).to start_service('pdns-recursor@server_01')
    end

    #
    # Tests for the config resource
    #

    it 'creates pdns config directory' do
      expect(chef_run).to create_directory('/etc/pdns-recursor')
      .with(owner: 'root', group: 'root', mode: '0755')
    end

    it 'creates pdns recursor unix user' do
      expect(chef_run).to create_user('pdns-recursor')
      .with(home: '/', shell: '/sbin/nologin', system: true)
    end

    it 'creates a pdns recursor unix group' do
      expect(chef_run).to create_group('pdns-recursor')
      .with(members: ['pdns-recursor'], system: true)
    end

    it 'creates a recursor instance config' do
      expect(chef_run).to create_template('/etc/pdns-recursor/recursor-server_01.conf')
      .with(owner: 'root', group: 'root', mode: '0640')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
