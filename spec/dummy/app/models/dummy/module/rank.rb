# Implementation of {Metasploit::Model::Module::Rank} to allow testing of {Metasploit::Model::Module::Rank}
# using an in-memory ActiveModel and use of factories.
class Dummy::Module::Rank < Metasploit::Model::Base
  include Metasploit::Model::Module::Rank

  #
  # Attributes
  #

  # @!attribute [rw] name
  #   The name of the rank.
  #
  #   @return [String]
  attr_accessor :name

  # @!attribute [rw] number
  #   The numerical value of the rank.  Higher numbers are better.
  #
  #   @return [Integer]
  attr_accessor :number
end