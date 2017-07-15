require 'spec_helper'

RSpec.describe Pdns::PdnsAuthoritativeHelpers do
  subject do
    class DummyClass < Chef::Node
      include Pdns::PdnsAuthoritativeHelpers
    end
    DummyClass.new
  end

  describe '#systemd_name' do
    context 'when no unique name has been given' do
      let(:name) { nil }
      it 'returns the service name without a unique name' do
        expect(subject.systemd_name(name)).to eq 'pdns@'
      end
    end

    context 'when a name has been given' do
      let(:name) { 'test' }
      it 'returns the service name with a unique name' do
        expect(subject.systemd_name(name)).to eq 'pdns@test'
      end
    end
  end

  describe '#sysvinit_name' do
    context 'when no unique name has been given' do
      let(:name) { nil }
      it 'returns the service name without a unique name' do
        expect(subject.sysvinit_name(name)).to eq 'pdns-authoritative_'
      end
    end

    context 'when a name has been given' do
      let(:name) { 'test' }
      it 'returns the service name with a unique name' do
        expect(subject.sysvinit_name(name)).to eq 'pdns-authoritative_test'
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
    context 'when no unique name has been given' do
      let(:name) { nil }
      it 'returns the service name without a unique name' do
        expect(subject.systemd_name(name)).to eq 'pdns-recursor@'
      end
    end

    context 'when a name has been given' do
      let(:name) { 'test' }
      it 'returns the service name with a unique name' do
        expect(subject.systemd_name(name)).to eq 'pdns-recursor@test'
      end
    end
  end

  describe '#sysvinit_name' do
    context 'when no unique name has been given' do
      let(:name) { nil }
      it 'returns the service name without a unique name' do
        expect(subject.sysvinit_name(name)).to eq 'pdns-recursor_'
      end
    end

    context 'when a name has been given' do
      let(:name) { 'test' }
      it 'returns the service name with a unique name' do
        expect(subject.sysvinit_name(name)).to eq 'pdns-recursor_test'
      end
    end
  end
end
