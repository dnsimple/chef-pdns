require 'spec_helper'

RSpec.describe Pdns::PdnsAuthoritativeHelpers do
  class DummyClass < Chef::Node
    include Pdns::PdnsAuthoritativeHelpers
  end
  subject { DummyClass.new }

  describe '#sysvinit_name' do
    context 'without a name' do
      let(:instance) { nil }
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
end
