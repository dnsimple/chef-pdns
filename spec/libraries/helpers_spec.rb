require 'spec_helper'

RSpec.describe Pdns::Helpers do
  subject do
    class DummyClass < Chef::Node
      include Pdns::Helpers
    end
    DummyClass.new
  end

  describe '#default_user_attributes' do
    context 'when platform is debian' do
      it 'returns a Mash for the Debian system user and home path' do
        allow(subject).to receive(:[]).with('platform_family').and_return('debian')
        expect(subject.default_user_attributes).to eq Mash.new(home: '/var/spool/powerdns', shell: '/bin/false')
      end
    end

    context 'when platform is rhel' do
      it 'returns a Mash for the RHEL system user and home path' do
        allow(subject).to receive(:[]).with('platform_family').and_return('rhel')
        expect(subject.default_user_attributes).to eq Mash.new(home: '/', shell: '/sbin/nologin')
      end
    end
  end
end

RSpec.describe Pdns::PdnsRecursorHelpers do
  subject do
    class DummyClass < Chef::Node
      include Pdns::PdnsRecursorHelpers
    end
    DummyClass.new
  end

  describe '#systemd_name' do
    context 'without a name' do
      let(:instance) { '' }
      it 'returns the service name without a specific name' do
        expect(subject.sysvinit_name(instance)).to eq 'pdns-recursor'
      end
    end

    context 'with a name' do
      let(:instance) { 'foo' }
      it 'returns the service name with a virtual instance name' do
        expect(subject.sysvinit_name(instance)).to eq('pdns-recursor-foo')
      end
    end
  end

  describe '#sysvinit_name' do
    context 'without a name' do
      let(:instance) { '' }
      it 'returns the service name without a specific name' do
        expect(subject.sysvinit_name(instance)).to eq 'pdns-recursor'
      end
    end

    context 'with a name' do
      let(:instance) { 'foo' }
      it 'returns the service name with a virtual instance name' do
        expect(subject.sysvinit_name(instance)).to eq('pdns-recursor-foo')
      end
    end
  end

  describe '#default_recursor_run_user' do
    context 'when platform is debian' do
      it 'returns the recursor Debian system user' do
        allow(subject).to receive(:[]).with('platform_family').and_return('debian')
        expect(subject.default_recursor_run_user).to eq 'pdns'
      end
    end

    context 'when platform is rhel' do
      it 'returns the recursor RHEL system user' do
        allow(subject).to receive(:[]).with('platform_family').and_return('rhel')
        expect(subject.default_recursor_run_user).to eq 'pdns-recursor'
      end
    end
  end

  describe '#default_recursor_config_directory' do
    context 'when platform is debian' do
      it 'retuns the default Debian configuration directory for a recursor' do
        allow(subject).to receive(:[]).with('platform_family').and_return('debian')
        expect(subject.default_recursor_config_directory).to eq '/etc/powerdns'
      end
    end

    context 'when platform is rhel' do
      it 'retuns the default  RHEL configuration directory for a recursor' do
        allow(subject).to receive(:[]).with('platform_family').and_return('rhel')
        expect(subject.default_recursor_config_directory).to eq '/etc/pdns-recursor'
      end
    end
  end

  describe '#recursor_instance_config' do
    context 'without a name' do
      let(:instance) { '' }
      it 'returns the default configuration' do
        expect(subject.recursor_instance_config(instance)).to eq 'pdns-recursor.conf'
      end
    end

    context 'with a name' do
      let(:instance) { 'foo' }
      it 'returns the config with a virtual instance name' do
        expect(subject.recursor_instance_config(instance)).to eq('recursor-foo.conf')
      end
    end
  end
end

RSpec.describe Pdns::PdnsAuthoritativeHelpers do
  subject do
    class DummyClass < Chef::Node
      include Pdns::PdnsAuthoritativeHelpers
    end
    DummyClass.new
  end

  describe '#systemd_name' do
    context 'without a name' do
      let(:instance) { '' }
      it 'returns the service name without a specific name' do
        expect(subject.sysvinit_name(instance)).to eq 'pdns'
      end
    end

    context 'with a name' do
      let(:instance) { 'foo' }
      it 'returns the service name with a virtual instance name' do
        expect(subject.sysvinit_name(instance)).to eq('pdns-foo')
      end
    end
  end

  describe '#sysvinit_name' do
    context 'without a name' do
      let(:instance) { '' }
      it 'returns the service name without a specific name' do
        expect(subject.sysvinit_name(instance)).to eq 'pdns'
      end
    end

    context 'with a name' do
      let(:instance) { 'foo' }
      it 'returns the service name with a virtual instance name' do
        expect(subject.sysvinit_name(instance)).to eq('pdns-foo')
      end
    end
  end

  describe '#authoritative_instance_config' do
    context 'without a name' do
      let(:instance) { '' }
      it 'returns the default configuration' do
        expect(subject.authoritative_instance_config(instance)).to eq 'pdns.conf'
      end
    end

    context 'with a name' do
      let(:instance) { 'foo' }
      it 'returns the config with a virtual instance name' do
        expect(subject.authoritative_instance_config(instance)).to eq('pdns-foo.conf')
      end
    end
  end

  describe '#default_authoritative_run_user' do
    it 'returns the authoritative system user' do
      expect(subject.default_authoritative_run_user).to eq('pdns')
    end
  end

  describe '#default_authoritative_config_directory' do
    context 'when platform is debian' do
      it 'returns the default configuration directory for Debian pdns server' do
        allow(subject).to receive(:[]).with('platform_family').and_return('debian')
        expect(subject.default_authoritative_config_directory).to eq('/etc/powerdns')
      end
    end

    context 'when platform is rhel' do
      let(:platform_family) { 'rhel' }
      it 'returns the default configuration directory for RHEL pdns server' do
        allow(subject).to receive(:[]).with('platform_family').and_return('rhel')
        expect(subject.default_authoritative_config_directory).to eq('/etc/pdns')
      end
    end
  end
end
