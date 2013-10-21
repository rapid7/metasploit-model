require 'spec_helper'

describe Metasploit::Model::Platform,
         # setting the metadata type makes rspec-rails include RSpec::Rails::ModelExampleGroup, which includes a better
         # be_valid matcher that will print full error messages
         type: :module do
  it_should_behave_like 'Metasploit::Model::Platform',
                        namespace_name: 'Dummy' do
    def attribute_type(attribute)
      type_by_attribute = {
          fully_qualified_name: :string
      }

      type_by_attribute.fetch(attribute)
    end
  end

  # @note Not tested in 'Metasploit::Model::Platform' shared example because it is a module method and not a class
  #   method because seeding should always refer back to {Metasploit::Model::Platform} and not the classes in which
  #   it is included.
  context 'fully_qualified_names' do
    subject(:fully_qualified_names) do
      described_class.fully_qualified_names
    end

    it { should include 'AIX' }
    it { should include 'Android' }
    it { should include 'BSD' }
    it { should include 'BSDi' }
    it { should include 'Cisco' }
    it { should include 'FreeBSD' }
    it { should include 'HPUX' }
    it { should include 'IRIX' }
    it { should include 'Java' }
    it { should include 'Javascript' }
    it { should include 'NetBSD' }
    it { should include 'Netware' }
    it { should include 'OpenBSD' }
    it { should include 'OSX' }
    it { should include 'PHP' }
    it { should include 'Python' }
    it { should include 'Ruby' }

    it { should include 'Solaris'}
    it { should include 'Solaris 4' }
    it { should include 'Solaris 5' }
    it { should include 'Solaris 6' }
    it { should include 'Solaris 7' }
    it { should include 'Solaris 8' }
    it { should include 'Solaris 9' }
    it { should include 'Solaris 10' }

    it { should include 'Windows' }

    it { should include 'Windows 95' }

    it { should include 'Windows 98' }
    it { should include 'Windows 98 FE' }
    it { should include 'Windows 98 SE' }

    it { should include 'Windows ME' }

    it { should include 'Windows NT' }
    it { should include 'Windows NT SP0' }
    it { should include 'Windows NT SP1' }
    it { should include 'Windows NT SP2' }
    it { should include 'Windows NT SP3' }
    it { should include 'Windows NT SP4' }
    it { should include 'Windows NT SP5' }
    it { should include 'Windows NT SP6' }
    it { should include 'Windows NT SP6a' }

    it { should include 'Windows 2000' }
    it { should include 'Windows 2000 SP0' }
    it { should include 'Windows 2000 SP1' }
    it { should include 'Windows 2000 SP2' }
    it { should include 'Windows 2000 SP3' }
    it { should include 'Windows 2000 SP4' }

    it { should include 'Windows XP' }
    it { should include 'Windows XP SP0' }
    it { should include 'Windows XP SP1' }
    it { should include 'Windows XP SP2' }
    it { should include 'Windows XP SP3' }

    it { should include 'Windows 2003' }
    it { should include 'Windows 2003 SP0' }
    it { should include 'Windows 2003 SP1' }

    it { should include 'Windows Vista' }
    it { should include 'Windows Vista SP0' }
    it { should include 'Windows Vista SP1' }

    it { should include 'Windows 7' }

    it { should include 'UNIX' }
  end
end