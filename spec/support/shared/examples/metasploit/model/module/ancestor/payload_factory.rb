shared_examples_for 'Metasploit::Model::Module::Ancestor payload factory' do |options={}|
  options.assert_valid_keys(:handler_type)

  should_have_handler_type = options[:handler_type]

  its(:module_type) { should == 'payload' }

  context 'contents' do
    include_context 'Metasploit::Model::Module::Ancestor factory contents'

    context 'metasploit_module' do
      include_context 'Metasploit::Model::Module::Ancestor factory contents metasploit_module'

      it { should be_a Module }
      it { should_not be_a Class }

      # nil means unknown/indeterminate.  true or false cause specific testing
      unless should_have_handler_type.nil?
        if should_have_handler_type
          method = :should
        else
          method = :should_not
        end

        it { send(method, respond_to(:handler_type_alias)) }

        if should_have_handler_type
          let(:handler_module) do
            metasploit_module.handler_module
          end

          context 'handler_module' do
            subject do
              handler_module
            end

            it_should_behave_like 'Metasploit::Model::Module::Handler'

            context 'handler_type' do
              subject(:handler_type) do
                handler_module.handler_type
              end

              it 'should be Metasploit::Model::Module::Ancestor#handler_type' do
                handler_type.should == module_ancestor.handler_type
              end
            end
          end

          context 'handler_type_alias' do
            subject(:handler_type_alias) do
              metasploit_module.handler_type_alias
            end

            it 'should delegate to handler_module' do
              handler_module.should_receive(:handler_type)

              handler_type_alias
            end

            it 'should be #handler_type' do
              handler_type_alias.should == module_ancestor.handler_type
            end
          end
        end
      end
    end
  end
end