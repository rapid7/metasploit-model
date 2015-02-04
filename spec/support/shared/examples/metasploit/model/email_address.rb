Metasploit::Model::Spec.shared_examples_for 'EmailAddress' do
  context 'derivations' do
    context 'with #full derived' do
      before(:each) do
        email_address.full = email_address.derived_full
      end

      it_should_behave_like 'derives', :domain, :validates => true
      it_should_behave_like 'derives', :local, :validates => true
    end

    it_should_behave_like 'derives', :full, :validates => true
  end

  context 'factories' do
    context email_address_factory do
      subject(email_address_factory) do
        FactoryGirl.build(email_address_factory)
      end

      it { should be_valid }
    end
  end

  context 'search' do
    context 'attributes' do
      it_should_behave_like 'search_attribute', :domain, :type => :string
      it_should_behave_like 'search_attribute', :full, :type => :string
      it_should_behave_like 'search_attribute', :local, :type => :string
    end
  end

  context 'validations' do
    it { should validate_presence_of :domain }
    it { should validate_presence_of :local }
  end

  context '#derived_domain' do
    subject(:derived_domain) do
      email_address.derived_domain
    end

    before(:each) do
      email_address.full = full
    end

    context 'with #full' do
      let(:domain) do
        FactoryGirl.generate :metasploit_model_email_address_domain
      end

      let(:local) do
        FactoryGirl.generate :metasploit_model_email_address_local
      end

      context "with '@'" do
        let(:full) do
          "#{local}@#{domain}"
        end


        context 'with local before @' do
          it "should be portion after '@'" do
            derived_domain.should == domain
          end
        end

        context 'without local before @' do
          let(:local) do
            ''
          end

          it "should be portion after '@'" do
            derived_domain.should == domain
          end
        end
      end

      context "without '@'" do
        let(:full) do
          local
        end

        it { should be_nil }
      end
    end

    context 'without #full' do
      let(:full) do
        ''
      end

      it { should be_nil }
    end
  end

  context '#derived_full' do
    subject(:derived_full) do
      email_address.derived_full
    end

    before(:each) do
      email_address.domain = domain
      email_address.local = local
    end

    context 'with domain' do
      let(:domain) do
        FactoryGirl.generate :metasploit_model_email_address_domain
      end

      context 'with #local' do
        let(:local) do
          FactoryGirl.generate :metasploit_model_email_address_local
        end

        it 'should <local>@<domain>' do
          derived_full.should == "#{local}@#{domain}"
        end
      end

      context 'without #local' do
        let(:local) do
          ''
        end

        it { should be_nil }
      end
    end

    context 'without #domain' do
      let(:domain) do
        ''
      end

      context 'with #local' do
        let(:local) do
          FactoryGirl.generate :metasploit_model_email_address_local
        end

        it { should be_nil }
      end

      context 'without #local' do
        let(:local) do
          ''
        end

        it { should be_nil }
      end
    end
  end

  context '#derived_local' do
    subject(:derived_local) do
      email_address.derived_local
    end

    before(:each) do
      email_address.full = full
    end

    context 'with #full' do
      let(:domain) do
        FactoryGirl.generate :metasploit_model_email_address_domain
      end

      let(:local) do
        FactoryGirl.generate :metasploit_model_email_address_local
      end

      context "with '@'" do
        let(:full) do
          "#{local}@#{domain}"
        end


        context "with domain after '@'" do
          it "should be portion before '@'" do
            derived_local.should == local
          end
        end

        context "without domain after '@'" do
          let(:local) do
            ''
          end

          it "should be portion before '@'" do
            derived_local.should == local
          end
        end
      end

      context "without '@'" do
        let(:full) do
          local
        end

        it 'should be entirety of #full' do
          derived_local.should == full
        end
      end
    end

    context 'without #full' do
      let(:full) do
        ''
      end

      it { should be_nil }
    end
  end
end