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

    it 'adds apt repository' do
      expect(chef_run).to add_apt_repository('powerdns-recursor')
    end

    it 'creates apt pin for pdns' do
      expect(chef_run).to add_apt_preference('pdns-*')
    end

    it 'installs pdns package' do
      expect(chef_run).to install_apt_package('pdns-recursor').with(version: '3.7.4')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
