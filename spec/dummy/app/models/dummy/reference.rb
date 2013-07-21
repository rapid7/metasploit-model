# Implementation of {Metasploit::Model::Reference} to allow testing of {Metasploit::Model::Reference} using an in-memory
# ActiveModel and use of factories.
class Dummy::Reference < Metasploit::Model::Base
  include Metasploit::Model::Reference

  #
  # Associations
  #

  # @!attribute [rw] authority
  #   The {Metasploit::Model::Authority authority} that assigned {#designation}.
  #
  #   @return [Metasploit::Model::Authority, nil]
  attr_accessor :authority

  #
  # Attributes
  #

  # @!attribute [rw] designation
  #   A designation (usually a string of numbers and dashes) assigned by {#authority}.
  #
  #   @return [String, nil]
  attr_accessor :designation

  # @!attribute [rw] url
  #   URL to web page with information about referenced exploit.
  #
  #   @return [String, nil]
  attr_accessor :url
end
