require 'spec_helper'

describe Metasploit::Model::Validators do
  let(:base_class) do
    # capture for Module.new scope
    described_class = self.described_class

    Module.new do
      extend described_class
    end
  end

  context 'autoload_validators' do
    subject(:autoload_validators) do
      base_class.autoload_validators
    end

    let(:validators_pathname) do
      Pathname.new('validators')
    end

    before(:each) do
      @before_autoload_paths = ActiveSupport::Dependencies.autoload_paths
      ActiveSupport::Dependencies.autoload_paths.clear

      base_class.stub(:validators_pathname => validators_pathname)
    end

    after(:each) do
      ActiveSupport::Dependencies.autoload_paths = @before_autoload_paths
    end

    context 'with validators_path in ActiveSupport::Dependencies.autoload_paths' do
      before(:each) do
        ActiveSupport::Dependencies.autoload_paths << validators_pathname.to_path
      end

      it 'should not add path to ActiveSupport::Dependencies.autoload_paths' do
        expect {
          autoload_validators
        }.to_not change(ActiveSupport::Dependencies, :autoload_paths)
      end
    end

    context 'without validators_path in ActiveSupport::Dependencies.autoload_paths' do
      it 'should add path to ActiveSupport::Dependencies.autoload_paths' do
        autoload_validators

        ActiveSupport::Dependencies.autoload_paths.should include(validators_pathname.to_path)
      end
    end
  end

  context 'validators_pathname' do
    subject(:validators_pathname) do
      base_class.validators_pathname
    end

    it 'should be a child of app_pathname' do
      app_pathname = double('app Pathname')

      app_pathname.should_receive(:join).with('validators')
      base_class.should_receive(:app_pathname).and_return(app_pathname)

      validators_pathname
    end
  end
end