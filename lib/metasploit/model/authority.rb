module Metasploit
  module Model
    # Code shared between `Mdm::Authority` and `Metasploit::Framework::Authority`.
    module Authority
      extend ActiveSupport::Concern

      #
      # CONSTANTS
      #

      # Attributes for seeds.  Ensures that in-database seeds for `Mdm::Authority` and in-memory seeds for
      # `Metasploit::Framework::Authority` are the same.
      SEED_ATTRIBUTES = [
          {
              :abbreviation => 'BID',
              :obsolete => false,
              :summary => 'BuqTraq ID',
              :url => 'http://www.securityfocus.com/bid'
          },
          {
              :abbreviation => 'CVE',
              :obsolete => false,
              :summary => 'Common Vulnerabilities and Exposures',
              :url => 'http://cvedetails.com'
          },
          {
              :abbreviation => 'CWE',
              :obsolete => false,
              :summary => 'Common Weakness Enumeration',
              :url => 'https://cwe.mitre.org/data/index.html'
          },
          {
              :abbreviation => 'MIL',
              :obsolete => true,
              :summary => 'milw0rm',
              :url => 'https://en.wikipedia.org/wiki/Milw0rm'
          },
          {
              :abbreviation => 'MSB',
              :obsolete => false,
              :summary => 'Microsoft Security Bulletin',
              :url => 'http://www.microsoft.com/technet/security/bulletin'
          },
          {
              :abbreviation => 'OSVDB',
              :obsolete => false,
              :summary => 'Open Sourced Vulnerability Database',
              :url => 'http://osvdb.org'
          },
          {
              :abbreviation => 'PMASA',
              :obsolete => false,
              :summary => 'phpMyAdmin Security Announcement',
              :url => 'http://www.phpmyadmin.net/home_page/security/'
          },
          {
              :abbreviation => 'SECUNIA',
              :obsolete => false,
              :summary => 'Secunia',
              :url => 'https://secunia.com/advisories'
          },
          {
              :abbreviation => 'US-CERT-VU',
              :obsolete => false,
              :summary => 'United States Computer Emergency Readiness Team Vulnerability Notes Database',
              :url => 'http://www.kb.cert.org/vuls'
          },
          {
              :abbreviation => 'waraxe',
              :obsolete => false,
              :summary => 'Waraxe Advisories',
              :url => 'http://www.waraxe.us/content-cat-1.html'
          }
      ]

      included do
        include ActiveModel::MassAssignmentSecurity
        include ActiveModel::Validations

        #
        # Mass Assignment Security
        #

        attr_accessible :abbreviation
        attr_accessible :obsolete
        attr_accessible :summary
        attr_accessible :url

        #
        # Validations
        #

        validates :abbreviation,
                  :presence => true
      end

      #
      # Associations
      #

      # @!attribute [rw] references
      #   {Metasploit::Model::Reference References} that use this authority's scheme for their
      #   {Metasploit::Model::Reference#authority}.
      #
      #   @return [Array<Metasploit::Model::Reference>]

      # @!attribute [r] module_instances
      #   {Metasploit::Model::Module::Instance Modules} that have a reference with this authority.
      #
      #   @return [Array<Metasploit::Model::Module::Instance>]

      # @!attribute [r] vulns
      #   Vulnerabilities that have a reference under this authority.
      #
      #   @return [Array<Metasploit::Model::Vuln>]

      #
      # Attributes
      #

      # @!attribute [rw] abbreviation
      #   Abbreviation or initialism for authority, such as CVE for 'Common Vulnerability and Exposures'.
      #
      #   @return [String]

      # @!attribute [rw] obsolete
      #   Whether this authority is obsolete and no longer exists on the internet.
      #
      #   @return [false]
      #   @return [true] {#url} may be `nil` because authory no longer has a web site.

      # @!attribute [rw] summary
      #   An expansion of the {#abbreviation}.
      #
      #   @return [String, nil]

      # @!attribute [rw] url
      #   URL to the authority's home page or root URL for their {#references} database.
      #
      #   @return [String, nil]

      #
      # Instance Methods
      #

      # Returns the {Metasploit::Model::Reference#url URL} for a {Metasploit::Model::Reference#designation designation}.
      #
      # @param designation [String] {Metasploit::Model::Reference#designation}.
      # @return [String] {Metasploit::Model::Reference#url}
      # @return [nil] if this {Metasploit::Model::Authority} is {#obsolete}.
      # @return [nil] if this {Metasploit::Model::Authority} does have a way to derive URLS from designations.
      def designation_url(designation)
        url = nil

        if extension
          url = extension.designation_url(designation)
        end

        url
      end

      # Returns module that include authority specific methods.
      #
      # @return [Module] if {#abbreviation} has a corresponding module under the Metasploit::Model::Authority namespace.
      # @return [nil] otherwise.
      def extension
        begin
          extension_name.constantize
        rescue NameError
          nil
        end
      end

      # Returns name of module that includes authority specific methods.
      #
      # @return [String] unless {#abbreviation} is blank.
      # @return [nil] if {#abbreviation} is blank.
      def extension_name
        extension_name = nil

        unless abbreviation.blank?
          # underscore before camelize to eliminate -'s
          relative_model_name = abbreviation.underscore.camelize
          # don't scope to self.class.name so that authority extension are always resolved the same in Mdm and
          # Metasploit::Framework.
          extension_name = "Metasploit::Model::Authority::#{relative_model_name}"
        end

        extension_name
      end
    end
  end
end