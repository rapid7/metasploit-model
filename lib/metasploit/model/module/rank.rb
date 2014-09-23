# Code shared between `Mdm::Module::Rank` and `Metasploit::Framework::Module::Rank`.
module Metasploit::Model::Module::Rank
  extend ActiveModel::Naming
  extend ActiveSupport::Concern

  include Metasploit::Model::Translation

  #
  # CONSTANTS
  #

  # Regular expression to ensure that {#name} is a word starting with a capital letter
  NAME_REGEXP = /\A[A-Z][a-z]+\Z/

  # Converts {#name} to {#number}.  Used for seeding.  Seeds exist so that reports can use module_ranks to get the
  # name of a rank without having to duplicate this constant.
  NUMBER_BY_NAME = {
      'Manual' => 0,
      'Low' => 100,
      'Average' => 200,
      'Normal' => 300,
      'Good' => 400,
      'Great' => 500,
      'Excellent' => 600
  }
  # Converts {#number} to {#name}.  Used to convert *Ranking constants used in `Msf::Modules` back to Strings.
  NAME_BY_NUMBER = NUMBER_BY_NAME.invert

  included do
    include ActiveModel::MassAssignmentSecurity
    include ActiveModel::Validations
    include Metasploit::Model::Search

    #
    # Mass Assignment Security
    #

    attr_accessible :name
    attr_accessible :number

    #
    # Search Attributes
    #

    search_attribute :name, :type => :string
    search_attribute :number, :type => :integer

    #
    # Validations
    #

    validates :name,
              # To ensure NUMBER_BY_NAME and seeds stay in sync.
              :inclusion => {
                  :in => NUMBER_BY_NAME.keys
              },
              # To ensure new seeds follow pattern.
              :format => {
                  :with => NAME_REGEXP
              }
    validates :number,
              # to ensure NUMBER_BY_NAME and seeds stay in sync.
              :inclusion => {
                  :in => NUMBER_BY_NAME.values
              },
              # To ensure new seeds follow pattern.
              :numericality => {
                  :only_integer => true
              }
  end

  #
  # Attributes
  #

  # @!attribute [rw] name
  #   The name of the rank.
  #
  #   @return [String]

  # @!attribute [rw] number
  #   The numerical value of the rank.  Higher numbers are better.
  #
  #   @return [Integer]
end
