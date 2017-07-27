require 'spec_helper'

# RSpec.describe Pdns::Helpers do
#   subject do
#     class DummyClass < Chef::Node
#       include Pdns::Helpers
#     end
#     DummyClass.new
#   end

#   describe '#default_user_attributes' do


# end

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

  # default_recursor_run_user
  # default_recursor_config_directory

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

  # default_authoritative_run_user
  # backend_package_per_platform
  # default_authoritative_config_directory

end
