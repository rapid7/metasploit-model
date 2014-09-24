# Concern for sharing common code between `Mdm::Module::Path` and `Metasploit::Framework::Module::Path`.  Define
# {#gem}, {#name}, and {#real_path} by following the abstract instructions for each attribute.
module Metasploit::Model::Module::Path
  extend ActiveModel::Naming
  extend ActiveSupport::Concern

  include Metasploit::Model::NilifyBlanks
  include Metasploit::Model::Translation

  included do
    include ActiveModel::Dirty
    include ActiveModel::MassAssignmentSecurity
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks
    include Metasploit::Model::RealPathname

    #
    # Callbacks
    #

    nilify_blank :gem,
                 :name
    before_validation :normalize_real_path

    #
    # Mass Assignment Security
    #

    attr_accessible :gem
    attr_accessible :name
    attr_accessible :real_path

    #
    # Validations
    #

    validate :directory
    validate :gem_and_name
  end

  #
  # Attributes
  #

  # @!attribute [rw] gem
  #   @abstract In an ActiveModel, this should be an `attr_accessor :gem`.  In an ActiveRecord, this should be a
  #     string gem column.
  #
  #   The name of the gem that is adding this module path to metasploit-framework.  For paths normally added by
  #   metasploit-framework itself, this would be `'metasploit-framework'`, while for Metasploit Pro this would be
  #   `'metasploit-pro'`.  The name used for `gem` does not have to be a gem on rubygems, it just functions as a
  #   namespace for {#name} so that projects using metasploit-framework do not need to worry about collisions on
  #   {#name} which could disrupt the cache behavior.
  #
  #   @return [String]

  # @!attribute [rw] name
  #   @abstract In an ActiveModel, this should be an `attr_accessor :name`.  In an ActiveRecord, this should be a
  #     string name column.
  #
  #   The name of the module path scoped to {#gem}.  {#gem} and {#name} uniquely identify this path so that if
  #   {#real_path} changes, the entire cache does not need to be invalidated because the change in {#real_path}
  #   will still be tied to the same ({#gem}, {#name}) tuple.
  #
  #   @return [String]

  # @!attribute [rw] real_path
  #   @abstract In an ActiveModel, this should be an `attr_accesor :real_path`.  In an ActiveRecord, this should
  #   be a text real_path column.
  #
  #   @note Non-real paths will be converted to real paths in a before validation callback, so take care to either
  #     pass real paths or pay attention when setting {#real_path} and then changing directories before
  #     validating.
  #
  #   The real (absolute) path to module path.
  #
  #   @return [String]

  #
  # Instance Methods
  #

  # Returns whether {#real_path} is a directory.
  #
  # @return [true] if {#real_path} is a directory.
  # @return [false] if {#real_path} is not a directory.
  def directory?
    directory = false

    if real_path and File.directory?(real_path)
      directory = true
    end

    directory
  end

  # Returns whether is a named path.
  #
  # @return [false] if gem is blank or name is blank.
  # @return [true] if gem is not blank and name is not blank.
  def named?
    named = false

    if gem.present? and name.present?
      named = true
    end

    named
  end

  # Returns whether was a named path.  This is the equivalent of {#named?}, but checks the old, pre-change
  # values for {#gem} and {#name}.
  #
  # @return [false] is gem_was is blank or name_was is blank.
  # @return [true] if gem_was is not blank and name_was is not blank.
  def was_named?
    was_named = false

    if gem_was.present? and name_was.present?
      was_named = true
    end

    was_named
  end

  private

  # Validates that either {#directory?} is `true`.
  #
  # @return [void]
  def directory
    unless directory?
      errors[:real_path] << 'must be a directory'
    end
  end

  # Validates that either both {#gem} and {#name} are present or both are `nil`.
  #
  # @return [void]
  def gem_and_name
    if name.present? and gem.blank?
      errors[:gem] << "can't be blank if name is present"
    end

    if gem.present? and name.blank?
      errors[:name] << "can't be blank if gem is present"
    end
  end

  # If {#real_path} is set and exists on disk, then converts it to a real path to eliminate any symlinks.
  #
  # @return [void]
  # @see Metasploit::Model::File.realpath
  def normalize_real_path
    if real_path and File.exist?(real_path)
      self.real_path = Metasploit::Model::File.realpath(real_path)
    end
  end
end
