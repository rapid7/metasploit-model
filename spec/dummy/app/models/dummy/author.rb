# Implementation of {Metasploit::Model::Author} to allow testing of {Metasploit::Model::Author} using an in-memory
# ActiveModel and use of factories.
class Dummy::Author < Metasploit::Model::Base
  include Metasploit::Model::Author

  #
  # Attributes
  #

  # @!attribute [rw] name
  #   Full name (First + Last name) or handle of author.
  #
  #   @return [String]
  attr_accessor :name
end