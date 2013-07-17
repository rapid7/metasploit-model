# In-memory implementation of {Metasploit::Model::Module::Path} to allow testing of {Metasploit::Model::Module::Path} in
# an ActiveModel and use of factories.
class Dummy::Module::Path < Metasploit::Model::Base
  include Metasploit::Model::Module::Path

  #
  # Attributes Methods - used to track changed attributes
  #

  define_attribute_method :gem
  define_attribute_method :name

  #
  # Attributes
  #

  # @!attribute [rw] gem
  #   The gem that owns this path.
  #
  #   @return [String, nil]
  attr_accessor :gem

  # @!attribute [rw] name
  #   The name of this path, scoped to {#gem}.
  #
  #   @return [String, nil]
  attr_accessor :name

  # @!attribute [rw] real_path
  #   Real (absolute) path on-disk.
  #
  #   @return [String]
  attr_accessor :real_path

  #
  # Methods
  #

  # Updates {#gem} value and marks {#gem} as changed if `gem` differs from
  # {#gem}.
  #
  # @param gem [String, nil] (see #gem)
  # @return [String, nil] `gem`
  def gem=(gem)
    unless gem == @gem
      gem_will_change!
    end

    @gem = gem
  end

  # Updates {#name} value and marks {#name} as changed if `name` differs
  # from {#name}.
  #
  # @param name [String, nil] (see #name)
  # @return [String, nil] `name`
  def name=(name)
    unless name == @name
      name_will_change!
    end

    @name = name
  end
end