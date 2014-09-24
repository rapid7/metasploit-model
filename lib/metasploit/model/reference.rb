# Code shared between `Mdm::Reference` and `Metasploit::Framework::Reference`.
module Metasploit::Model::Reference
  extend ActiveModel::Naming
  extend ActiveSupport::Concern

  include Metasploit::Model::Translation

  included do
    include ActiveModel::MassAssignmentSecurity
    include ActiveModel::Validations
    include Metasploit::Model::Derivation
    include Metasploit::Model::Search

    #
    # Derivations
    #

    derives :url, :validate => false

    #
    # Mass Assignment Security
    #

    attr_accessible :designation
    attr_accessible :url

    #
    # Search Attributes
    #

    search_attribute :designation, :type => :string
    search_attribute :url, :type => :string

    #
    # Validations
    #

    validates :designation,
              :presence => {
                  :if => :authority?
              },
              :nil => {
                  :unless => :authority?
              }
    validates :url,
              :presence => {
                  :unless => :authority?
              }
  end

  #
  # Associations
  #

  # @!attribute [rw] authority
  #   The {Metasploit::Model::Authority authority} that assigned {#designation}.
  #
  #   @return [Metasploit::Model::Authority, nil]

  # @!attribute [r] module_instances
  #   {Metasploit::Model::Module::Instance Modules} that exploit this reference or describe a proof-of-concept (PoC)
  #   code that the module is based on.
  #
  #   @return [Array<Metasploit::Model::Module::Instance>]

  #
  # Attributes
  #

  # @!attribute [rw] designation
  #   A designation (usually a string of numbers and dashes) assigned by {#authority}.
  #
  #   @return [String, nil]

  # @!attribute [rw] url
  #   URL to web page with information about referenced exploit.
  #
  #   @return [String, nil]

  #
  # Instance Methods
  #

  # Returns whether {#authority} is not `nil`.
  #
  # @return [true] unless {#authority} is `nil`.
  # @return [false] if {#authority} is `nil`.
  def authority?
    authority.present?
  end

  # Derives {#url} based how {#authority} routes {#designation designations} to a URL.
  #
  # @return [String, nil]
  def derived_url
    derived = nil

    if authority and designation.present?
      derived = authority.designation_url(designation)
    end

    derived
  end
end
