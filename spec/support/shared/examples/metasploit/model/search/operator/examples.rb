shared_examples_for 'Metasploit::Model::Search::Operator::Examples' do
  context '#examples' do
    subject(:examples) do
      operator.examples
    end

    let(:examples_template) do
      ["%{name}:1001", "%{name}:100-2992"]
    end

    let(:klass) do
      Class.new(Metasploit::Model::Base)
    end

    let(:model) do
      'Klass'
    end

    let(:name) do
      'operator_name'
    end

    before(:each) do
      # klass needs to be named or model_name will fail.
      stub_const('Klass', klass)
      # since missing translations raise exceptions, and there is no translation for klass, have to stub out.
      klass.model_name.stub(:human).and_return(model)

      backend = I18n.backend

      unless backend.initialized?
        backend.send(:init_translations)
      end

      translations_by_locale = I18n.backend.send(:translations)
      english_translations = translations_by_locale.fetch(:en)
      metasploit_translations = english_translations.fetch(:metasploit)
      @metasploit_model_translations = metasploit_translations.fetch(:model)
      ancestors_translations = @metasploit_model_translations.fetch(:ancestors)

      @original_ancestors_translations = ancestors_translations.dup

      ancestors_translations.merge!(
        klass.model_name.i18n_key => {
          search: {
            operator: {
              names: {
                name.to_sym => {
                  examples: examples_template
                }
              }
            }
          }
        }
      )
    end

    after(:each) do
      @metasploit_model_translations[:ancestors] = @original_ancestors_translations
    end

    it 'should use #klass #i18n_scope to lookup translations specific to the #klass or one of its ancestors' do
      klass.should_receive(:i18n_scope).and_call_original

      examples
    end

    it 'should lookup ancestors of #klass to find translations specific to #klass or its ancestors' do
      klass.should_receive(:lookup_ancestors).and_call_original

      examples
    end

    it 'should use #class #i18n_scope to lookup translations specific to the operator class or one of its ancestors' do
      operator.class.should_receive(:i18n_scope)

      examples
    end

    it 'should lookup ancestors of the operator class to find translations specific to the operator class or one of its ancestors' do
      operator.class.should_receive(:lookup_ancestors).and_return([])

      examples
    end

    it "should pass #klass translation key for operator with the given name as the primary translation key" do
      I18n.should_receive(:translate).with(
          :"#{klass.i18n_scope}.ancestors.#{klass.model_name.i18n_key}.search.operator.names.#{name}.help",
          anything
      )

      examples
    end

    it 'should pass other translation keys as default option' do
      I18n.should_receive(:translate) do |_key, options|
        options.should be_a Hash

        default = options[:default]

        default.should be_an Array

        default.all? { |key|
          key.is_a? Symbol
        }.should be_true
      end

      examples
    end

    it 'should pass #name of operator as name option' do
      I18n.should_receive(:translate).with(
        anything,
        hash_including(name: name)
      )

      examples
    end

    it 'should pass the human model name of #klass as model option' do
      I18n.should_receive(:translate).with(
        anything,
        hash_including(model: klass.model_name.human)
      )

      examples
    end

    it 'should be translated correctly' do
      examples.should == examples_template.map { |str| str % { name: name } }
    end
  end
end