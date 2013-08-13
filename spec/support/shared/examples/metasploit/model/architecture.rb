shared_examples_for 'Metasploit::Model::Architecture' do
  context 'CONSTANTS' do
    context 'ABBREVIATIONS' do
      subject(:abbreviations) do
        described_class::ABBREVIATIONS
      end

      it 'should be an Array<String>' do
        abbreviations.should be_an Array

        abbreviations.each do |architecture|
          architecture.should be_a String
        end
      end

      it 'should include both endians of ARM' do
        abbreviations.should include('armbe')
        abbreviations.should include('armle')
      end

      it 'should include 32-bit and 64-bit versions of Cell Broadband Engine Architecture' do
        abbreviations.should include('cbea')
        abbreviations.should include('cbea64')
      end

      it 'should include cmd for command shell' do
        abbreviations.should include('cmd')
      end

      it 'should include java for Java Virtual Machine' do
        abbreviations.should include('java')
      end

      it 'should include endian-ware MIPS' do
        abbreviations.should include('mipsbe')
        abbreviations.should include('mipsle')
      end

      it 'should include php for PHP code' do
        abbreviations.should include('php')
      end

      it 'should include 32-bit and 64-bit PowerPC' do
        abbreviations.should include('ppc')
        abbreviations.should include('ppc64')
      end

      it 'should include ruby for Ruby code' do
        abbreviations.should include('ruby')
      end

      it 'should include sparc for Sparc' do
        abbreviations.should include('sparc')
      end

      it 'should include tty for Terminals' do
        abbreviations.should include('tty')
      end

      it 'should include 32-bit and 64-bit x86' do
        abbreviations.should include('x86')
        abbreviations.should include('x86_64')
      end
    end
  end

  context 'search' do
    context 'i18n_scope' do
      subject(:search_i18n_scope) do
        described_class.search_i18n_scope
      end

      it { should == 'metasploit.model.architecture' }
    end

    context 'attributes' do
      let(:base_class) do
        architecture_class
      end

      it_should_behave_like 'search_attribute', :abbreviation, :type => :string
      it_should_behave_like 'search_attribute', :bits, :type => :integer
      it_should_behave_like 'search_attribute', :endianness, :type => :string
      it_should_behave_like 'search_attribute', :family, :type => :string
    end
  end

  context 'validations' do
    context 'abbreviation' do
      # have to test inclusion validation manually because
      # ensure_inclusion_of(:abbreviation).in_array(described_class::ABBREVIATIONS).allow_nil does not work with
      # additional uniqueness validation.
      context 'ensure inclusion of abbreviation in ABBREVIATIONS' do
        let(:error) do
          'is not included in the list'
        end

        abbreviations = [
            'armbe',
            'armle',
            'cbea',
            'cbea64',
            'cmd',
            'java',
            'mipsbe',
            'mipsle',
            'php',
            'ppc',
            'ppc64',
            'ruby',
            'sparc',
            'tty',
            'x86',
            'x86_64'
        ]

        abbreviations.each do |abbreviation|
          context "with #{abbreviation.inspect}" do
            before(:each) do
              architecture.abbreviation = abbreviation

              architecture.valid?
            end

            it 'should not record error on abbreviation' do
              architecture.errors[:abbreviation].should_not include(error)
            end
          end
        end
      end
    end

    it { should ensure_inclusion_of(:bits).in_array(described_class::BITS).allow_nil }
    it { should ensure_inclusion_of(:endianness).in_array(described_class::ENDIANNESSES).allow_nil }
    it { should ensure_inclusion_of(:family).in_array(described_class::FAMILIES).allow_nil }
    it { should validate_presence_of(:summary) }
  end
end