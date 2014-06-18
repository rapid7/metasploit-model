require 'spec_helper'

describe Metasploit::Model::Engine do
  context 'config' do
    subject(:config) do
      described_class.config
    end

    context 'generators' do
      subject(:generators) do
        config.generators
      end

      context 'options' do
        subject(:options) do
          generators.options
        end

        context 'factory_girl' do
          subject(:factory_girl) do
            options[:factory_girl]
          end

          its([:dir]) { should == 'spec/factories' }
        end

        context 'rails' do
          subject(:rails) do
            options[:rails]
          end

          its([:assets]) { should be_false }
          its([:fixture_replacement]) { should == :factory_girl }
          its([:helper]) { should be_false }
          its([:test_framework]) { should == :rspec }
        end

        context 'rspec' do
          subject(:rspec) do
            options[:rspec]
          end

          its([:fixture]) { should be_false }
        end
      end
    end
  end

  context 'initializers' do
    subject(:initializers) do
      # need to use Rails's initialized copy of Dummy::Application so that initializers have the correct context when
      # run
      Rails.application.initializers
    end

    context 'metasploit-model.prepend_factory_path' do
      subject(:initializer) do
        initializers.find { |initializer|
          initializer.name == 'metasploit-model.prepend_factory_path'
        }
      end

      it 'should run after factory_girl.set_factory_paths' do
        initializer.after.should == 'factory_girl.set_factory_paths'
      end

      context 'running' do
        def run
          initializer.run
        end

        context 'with FactoryGirl defined' do
          it 'should prepend full path to spec/factories to FactoryGirl.definition_file_paths' do
            definition_file_path = Metasploit::Model.root.join('spec', 'factories')

            FactoryGirl.definition_file_paths.should_receive(:unshift).with(definition_file_path)

            run
          end
        end
      end
    end
  end
end