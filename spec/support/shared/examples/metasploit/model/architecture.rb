Metasploit::Model::Spec.shared_examples_for 'Architecture' do
  subject(:architecture) do
    # Architecture, don't have a factory, they have a sequence and can't use sequence generated architectures because
    # validators so tightly constraint values.
    architecture_class.new
  end

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

      it 'should include dalvik for Dalvik Virtual Machine in Google Android' do
        abbreviations.should include('dalvik')
      end

      it 'should include firefox for Firefox cross-platfomr add-on format' do
        expect(abbreviations).to include('firefox')
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

      it 'should include python for Python code' do
        abbreviations.should include('python')
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
    context 'attributes' do
      it_should_behave_like 'search_attribute',
                            :abbreviation,
                            type: {
                                set: :string
                            }
      it_should_behave_like 'search_attribute',
                            :bits,
                            type: {
                                set: :integer
                            }
      it_should_behave_like 'search_attribute',
                            :endianness,
                            type: {
                                set: :string
                            }
      it_should_behave_like 'search_attribute',
                            :family,
                            type: {
                                set: :string
                            }
    end
  end

  context 'seeds' do
    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          :abbreviation => 'armbe',
                          :bits => 32,
                          :endianness => 'big',
                          :family => 'arm',
                          :summary => 'Little-endian ARM'

    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          :abbreviation => 'armle',
                          :bits => 32,
                          :endianness => 'little',
                          :family => 'arm',
                          :summary => 'Big-endian ARM'

    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          :abbreviation => 'cbea',
                          :bits => 32,
                          :endianness => 'big',
                          :family => 'cbea',
                          :summary => '32-bit Cell Broadband Engine Architecture'

    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          :abbreviation => 'cbea64',
                          :bits => 64,
                          :endianness => 'big',
                          :family => 'cbea',
                          :summary => '64-bit Cell Broadband Engine Architecture'

    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          :abbreviation => 'cmd',
                          :bits => nil,
                          :endianness => nil,
                          :family => nil,
                          :summary => 'Command Injection'

    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          :abbreviation => 'dalvik',
                          :bits => nil,
                          :endianness => nil,
                          :family => nil,
                          :summary => 'Dalvik process virtual machine used in Google Android'

    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          abbreviation: 'firefox',
                          bits: nil,
                          endianness: nil,
                          family: nil,
                          summary: 'Firefox cross-platform add-on format'

    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          :abbreviation => 'java',
                          :bits => nil,
                          :endianness => 'big',
                          :family => nil,
                          :summary => 'Java'

    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          :abbreviation => 'mipsbe',
                          :bits => 32,
                          :endianness => 'big',
                          :family => 'mips',
                          :summary => 'Big-endian MIPS'

    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          :abbreviation => 'mipsle',
                          :bits => 32,
                          :endianness => 'little',
                          :family => 'mips',
                          :summary => 'Little-endian MIPS'

    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          :abbreviation => 'php',
                          :bits => nil,
                          :endianness => nil,
                          :family => nil,
                          :summary => 'PHP'

    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          :abbreviation => 'ppc',
                          :bits => 32,
                          :endianness => 'big',
                          :family => 'ppc',
                          :summary => '32-bit Peformance Optimization With Enhanced RISC - Performance Computing'

    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          :abbreviation => 'ppc64',
                          :bits => 64,
                          :endianness => 'big',
                          :family => 'ppc',
                          :summary => '64-bit Performance Optimization With Enhanced RISC - Performance Computing'

    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          :abbreviation => 'python',
                          :bits => nil,
                          :endianness => nil,
                          :family => nil,
                          :summary => 'Python'

    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          :abbreviation => 'ruby',
                          :bits => nil,
                          :endianness => nil,
                          :family => nil,
                          :summary => 'Ruby'

    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          :abbreviation => 'sparc',
                          :bits => nil,
                          :endianness => nil,
                          :family => 'sparc',
                          :summary => 'Scalable Processor ARChitecture'

    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          :abbreviation => 'tty',
                          :bits => nil,
                          :endianness => nil,
                          :family => nil,
                          :summary => '*nix terminal'

    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          :abbreviation => 'x86',
                          :bits => 32,
                          :endianness => 'little',
                          :family => 'x86',
                          :summary => '32-bit x86'

    it_should_behave_like 'Metasploit::Model::Architecture seed',
                          :abbreviation => 'x86_64',
                          :bits => 64,
                          :endianness => 'little',
                          :family => 'x86',
                          :summary => '64-bit x86'
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
            'dalvik',
            'firefox',
            'java',
            'mipsbe',
            'mipsle',
            'php',
            'ppc',
            'ppc64',
            'python',
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

  context 'abbreviation_set' do
    subject(:abbreviation_set) do
      architecture_class.abbreviation_set
    end

    it { should_not include nil }
    it { should include 'armbe' }
    it { should include 'armle' }
    it { should include 'cbea' }
    it { should include 'cbea64' }
    it { should include 'cmd' }
    it { should include 'dalvik' }
    it { should include 'firefox' }
    it { should include 'java' }
    it { should include 'mipsbe' }
    it { should include 'mipsle' }
    it { should include 'php' }
    it { should include 'ppc' }
    it { should include 'ppc64' }
    it { should include 'python' }
    it { should include 'ruby' }
    it { should include 'sparc' }
    it { should include 'tty' }
    it { should include 'x86' }
    it { should include 'x86_64' }
  end

  context 'bits_set' do
    subject(:bits_set) do
      architecture_class.bits_set
    end

    it { should_not include nil }
    it { should include 32 }
    it { should include 64 }
  end

  context 'endianness_set' do
    subject(:endianness_set) do
      architecture_class.endianness_set
    end

    it { should_not include nil }
    it { should include 'big' }
    it { should include 'little' }
  end

  context 'family_set' do
    subject(:family_set) do
      architecture_class.family_set
    end

    it { should_not include nil }
    it { should include 'arm' }
    it { should include 'cbea' }
    it { should include 'mips' }
    it { should include 'ppc' }
    it { should include 'sparc' }
    it { should include 'x86' }
  end
end