require 'spec_helper'

describe 'test::recursor_remove' do
  context 'on ubuntu platform' do
    let(:ubuntu_runner) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04',
        step_into: ['pdns_recursor'])
    end

    let(:chef_run) { ubuntu_runner.converge(described_recipe) }
    let(:version) { '4.0.4-1pdns.trusty' }

    it 'removes pdns package' do
      expect(chef_run).to remove_apt_package('pdns-recursor').with(version: version)
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
        node.automatic['packages']['centos-release']['version'] = '6'
      end
    end

    let(:chef_run) { rhel_runner.converge(described_recipe) }
    let(:version) { '4.0.4-1pdns.el6' }

    it 'removes pdns package with version' do
      expect(chef_run).to remove_yum_package('pdns-recursor').with(version: version)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end

