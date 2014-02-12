require 'spec_helper'

describe Metasploit::Model::Spec::Template do
  context 'root' do
    around(:each) do |example|
      old_root = described_class.root

      begin
        example.run
      ensure
        described_class.root = old_root
      end
    end

    it 'modifies subclass root when set' do
      expected = double('root')

      expect {
        described_class.root = expected
      }.to change(Metasploit::Model::Module::Ancestor::Spec::Template, :root).to(expected)
    end
  end
end