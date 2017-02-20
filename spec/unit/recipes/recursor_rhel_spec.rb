require 'spec_helper'

describe 'test::recursor_rhel' do
  context 'on rhel platform' do
    let(:rhel_runner) do
      ChefSpec::SoloRunner.new(
      platform: 'centos',
      version: '6.8',
      step_into: ['pdns_recursor', 'pdns_recursor_service']) do |node|
        node.automatic['packages']['centos-release']['version'] = '6'
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

    it 'enables pdns_recursor service' do
      expect(chef_run).to enable_service('pdns-recursor').with(pattern: 'pdns_recursor')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end