shared_examples_for 'Metasploit::Model::Authority' do
  context 'mass assignment security' do
    it { should allow_mass_assignment_of(:abbreviation) }
    it { should allow_mass_assignment_of(:obsolete) }
    it { should allow_mass_assignment_of(:summary) }
    it { should allow_mass_assignment_of(:url) }
  end

  context 'validations' do
    it { should validate_presence_of(:abbreviation) }
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
  end
end