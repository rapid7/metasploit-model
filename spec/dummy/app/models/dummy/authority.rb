# Implementation of {Metasploit::Model::Authority} to allow testing of {Metasploit::Model::Authority} using an in-memory
# ActiveModel and use of factories.
class Dummy::Authority < Metasploit::Model::Base
  include Metasploit::Model::Authority

  #
  # Attributes
  #

  # @!attribute [rw] abbreviation
  #   Abbreviation or initialism for authority, such as CVE for 'Common Vulnerability and Exposures'.
  #
  #   @return [String]
  attr_accessor :abbreviation

  # @!attribute [rw] obsolete
  #   Whether this authority is obsolete and no longer exists on the internet.
  #
  #   @return [false]
  #   @return [true] {#url} may be `nil` because authory no longer has a web site.
  attr_accessor :obsolete

  # @!attribute [rw] summary
  #   An expansion of the {#abbreviation}.
  #
  #   @return [String, nil]
  attr_accessor :summary

  # @!attribute [rw] url
  #   URL to the authority's home page or root URL for their {#references} database.
  #
  #   @return [String, nil]
  attr_accessor :url

  #
  # Methods
  #

  # Keep single instance of each set of attributes in {SEED_ATTRIBUTES} to emulate unique database seeds in-memory.
  #
  # @param abbreviation [String] {#abbreviation}
  # @return [Dummy::Authority]
  def self.with_abbreviation(abbreviation)
    unless instance_variable_defined? :@instance_by_abbreviation
      @instance_by_abbreviation = {}

      SEED_ATTRIBUTES.each do |attributes|
        instance = new(attributes)

        unless instance.valid?
          raise Metasploit::Model::Invalid.new(instance)
        end

        # freeze object to prevent specs from modifying them and interfering with other specs.
        instance.freeze

        @instance_by_abbreviation[instance.abbreviation] = instance
      end
    end

    @instance_by_abbreviation.fetch(abbreviation)
  end
end