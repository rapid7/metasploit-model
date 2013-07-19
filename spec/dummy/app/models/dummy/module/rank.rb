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

  # Keep single instance for each pair in {Metasploit::Model::Module::Rank::NUMBER_BY_NAME} to emulate unique database
  # seeds in-memory.
  #
  # @param name [String] {Dummy::Module::Rank#name}
  # @return [Dummy::Module::Rank]
  def self.by_name(name)
    unless instance_variable_defined? :@instance_by_name
      @instance_by_name = {}

      NUMBER_BY_NAME.each do |name, number|
        instance = new(:name => name, :number => number)

        unless instance.valid?
          raise Metasploit::Model::ModelInvalid.new(instance)
        end

        @instance_by_name[name] = instance
      end
    end

    @instance_by_name.fetch(name)
  end
end