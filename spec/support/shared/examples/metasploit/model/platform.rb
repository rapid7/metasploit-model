Metasploit::Model::Spec.shared_examples_for 'Platform' do
  platform_sequence = "#{factory_namespace}_#{relative_variable_name}"

  subject(:platform) do
    FactoryGirl.generate platform_sequence
  end

  context 'CONSTANTS' do
    context 'SEED_RELATIVE_NAME_TRIE' do
      subject(:seed_relative_name_tree) do
        described_class::SEED_RELATIVE_NAME_TREE
      end

      it { should include('AIX') }
      it { should include('Android') }
      it { should include('BSD') }
      it { should include('BSDi') }
      it { should include('Cisco') }
      it { should include('Firefox') }
      it { should include('FreeBSD') }
      it { should include('HPUX') }
      it { should include('IRIX') }
      it { should include('Java') }
      it { should include('Javascript') }
      it { should include('Linux') }
      it { should include('NetBSD') }
      it { should include('Netware') }
      it { should include('OpenBSD') }
      it { should include('OSX') }
      it { should include('PHP') }
      it { should include('Python') }
      it { should include('Ruby') }

      context "['Solaris']" do
        subject(:solaris) do
          seed_relative_name_tree['Solaris']
        end

        it { should include('4') }
        it { should include('5') }
        it { should include('6') }
        it { should include('7') }
        it { should include('8') }
        it { should include('9') }
        it { should include('10') }
      end

      context "['Windows']" do
        subject(:windows) do
          seed_relative_name_tree['Windows']
        end

        it { should include('95') }

        context "['98']" do
          subject(:ninety_eight) do
            windows['98']
          end

          it { should include('FE') }
          it { should include('SE') }
        end

        it { should include('ME') }

        context "['NT']" do
          subject(:nt) do
            windows['NT']
          end

          it { should include('SP0') }
          it { should include('SP1') }
          it { should include('SP2') }
          it { should include('SP3') }
          it { should include('SP4') }
          it { should include('SP5') }
          it { should include('SP6') }
          it { should include('SP6a') }
        end

        context "['2000']" do
          subject(:two_thousand) do
            windows['2000']
          end

          it { should include('SP0') }
          it { should include('SP1') }
          it { should include('SP2') }
          it { should include('SP3') }
          it { should include('SP4') }
        end

        context "['XP']" do
          subject(:xp) do
            windows['XP']
          end

          it { should include('SP0') }
          it { should include('SP1') }
          it { should include('SP2') }
          it { should include('SP3') }
        end

        context "['2003']" do
          subject(:two_thousand_three) do
            windows['2003']
          end

          it { should include('SP0') }
          it { should include('SP1') }
        end

        context "['Vista']" do
          subject(:vista) do
            windows['Vista']
          end

          it { should include('SP0') }
          it { should include('SP1') }
        end

        it { should include('7') }
      end

      it { should include('UNIX') }
    end
  end

  context 'derivations' do
    subject(:platform) do
      # can't use seeded platforms because they are frozen
      # have to tap to bypass mass-assignment security
      platform_class.new.tap { |platform|
        platform.parent = windows
        # need to use a real name or derivation won't be valid because it won't be in fully_qualified_names.
        platform.relative_name = 'XP'
      }
    end

    let(:windows) do
      platform_class.all.find { |platform|
        # need to use a real name or derivation won't be valid because it won't be in fully_qualified_names.
        platform.fully_qualified_name == 'Windows'
      }
    end

    it_should_behave_like 'derives', :fully_qualified_name, :validates => true
  end

  context 'mass assignment security' do
    it { should allow_mass_assignment_of(:relative_name) }
  end

  context 'search' do
    context 'attributes' do
      it_should_behave_like 'search_attribute',
                            :fully_qualified_name,
                            type: {
                                set: :string
                            }
    end
  end

  context 'validations' do
    subject(:platform) do
      # can't use seeded platforms because they are frozen
      platform_class.new
    end

    it { should validate_presence_of(:relative_name) }
  end

  context '#derived_fully_qualified_name' do
    subject(:derived_fully_qualified_name) do
      platform.derived_fully_qualified_name
    end

    context 'with #relative_name' do
      context 'with #parent' do
        let(:platform) do
          base_class.all.select { |platform|
            platform.parent.present?
          }.sample
        end

        it "should be '<parent.fully_qualified_name> <relative_name>'" do
          derived_fully_qualified_name.should == "#{platform.parent.fully_qualified_name} #{platform.relative_name}"
        end
      end

      context 'without #parent' do
        let(:platform) do
          base_class.all.reject { |platform|
            platform.parent.present?
          }.sample
        end

        it 'should be #relative_name' do
          derived_fully_qualified_name.should == platform.relative_name
        end
      end
    end

    context 'without #relative_name' do
      let(:platform) do
        platform_class.new
      end

      it { should be_nil }
    end
  end
end