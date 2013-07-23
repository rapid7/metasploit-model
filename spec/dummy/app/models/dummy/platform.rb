# Implementation of {Metasploit::Model::Platform} to allow testing of {Metasploit::Model::Platform} using an in-memory
# ActiveModel and use of factories.
class Dummy::Platform < Metasploit::Model::Base
  include Metasploit::Model::Platform

  #
  # Attributes
  #

  # @!attribute [rw] name
  #   The name of the platform
  #
  #   @return [String]
  attr_accessor :name
end

