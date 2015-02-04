Metasploit::Model::Spec.shared_examples_for 'Authority' do
  full_authority_factory = "full_#{authority_factory}"
  obsolete_authority_factory = "obsolete_#{authority_factory}"

  context 'factories' do
    context authority_factory do
      subject(authority_factory) do
        FactoryGirl.build(authority_factory)
      end

      it { should be_valid }
    end

    context full_authority_factory do
      subject(full_authority_factory) do
        FactoryGirl.build(full_authority_factory)
      end

      it { should be_valid }

      its(:summary) { should_not be_nil }
      its(:url) { should_not be_nil }
    end

    context obsolete_authority_factory do
      subject(obsolete_authority_factory) do
        FactoryGirl.build(obsolete_authority_factory)
      end

      it { should be_valid }

      its(:obsolete) { should be_true }
    end
  end

  context 'search' do
    context 'attributes' do
      it_should_behave_like 'search_attribute', :abbreviation, :type => :string
    end
  end

  context 'seeds' do
    it_should_behave_like 'Metasploit::Model::Authority seed',
                          :abbreviation => 'BID',
                          :extension_name => 'Metasploit::Model::Authority::Bid',
                          :obsolete => false,
                          :summary => 'BuqTraq ID',
                          :url => 'http://www.securityfocus.com/bid'

    it_should_behave_like 'Metasploit::Model::Authority seed',
                          :abbreviation => 'CVE',
                          :extension_name => 'Metasploit::Model::Authority::Cve',
                          :obsolete => false,
                          :summary => 'Common Vulnerabilities and Exposures',
                          :url => 'http://cvedetails.com'

    it_should_behave_like 'Metasploit::Model::Authority seed',
                          :abbreviation => 'MIL',
                          :extension_name => nil,
                          :obsolete => true,
                          :summary => 'milw0rm',
                          :url => 'https://en.wikipedia.org/wiki/Milw0rm'

    it_should_behave_like 'Metasploit::Model::Authority seed',
                          :abbreviation => 'MSB',
                          :extension_name => 'Metasploit::Model::Authority::Msb',
                          :obsolete => false,
                          :summary => 'Microsoft Security Bulletin',
                          :url => 'http://www.microsoft.com/technet/security/bulletin'

    it_should_behave_like 'Metasploit::Model::Authority seed',
                          :abbreviation => 'OSVDB',
                          :extension_name => 'Metasploit::Model::Authority::Osvdb',
                          :obsolete => false,
                          :summary => 'Open Sourced Vulnerability Database',
                          :url => 'http://osvdb.org'

    it_should_behave_like 'Metasploit::Model::Authority seed',
                          :abbreviation => 'PMASA',
                          :extension_name => 'Metasploit::Model::Authority::Pmasa',
                          :obsolete => false,
                          :summary => 'phpMyAdmin Security Announcement',
                          :url => 'http://www.phpmyadmin.net/home_page/security/'

    it_should_behave_like 'Metasploit::Model::Authority seed',
                          :abbreviation => 'SECUNIA',
                          :extension_name => 'Metasploit::Model::Authority::Secunia',
                          :obsolete => false,
                          :summary => 'Secunia',
                          :url => 'https://secunia.com/advisories'

    it_should_behave_like 'Metasploit::Model::Authority seed',
                          :abbreviation => 'US-CERT-VU',
                          :extension_name => 'Metasploit::Model::Authority::UsCertVu',
                          :obsolete => false,
                          :summary => 'United States Computer Emergency Readiness Team Vulnerability Notes Database',
                          :url => 'http://www.kb.cert.org/vuls'

    it_should_behave_like 'Metasploit::Model::Authority seed',
                          :abbreviation => 'waraxe',
                          :extension_name => 'Metasploit::Model::Authority::Waraxe',
                          :obsolete => false,
                          :summary => 'Waraxe Advisories',
                          :url => 'http://www.waraxe.us/content-cat-1.html'

    it_should_behave_like 'Metasploit::Model::Authority seed',
                          abbreviation: 'ZDI',
                          extension_name: 'Metasploit::Model::Authority::Zdi',
                          obsolete: false,
                          summary: 'Zero Day Initiative',
                          url: 'http://www.zerodayinitiative.com/advisories'
  end

  context 'validations' do
    it { should validate_presence_of(:abbreviation) }
  end
end