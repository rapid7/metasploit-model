# Processes {EXTENSION '.rb.erb'} templates to create {Metasploit::Model::Module::Ancestor#contents} that contain the
# same metadata as the {Metasploit::Model::Module::Ancestor},
# {Metasploit::Model::Module::Class}, {Metasploit::Model::Module::Instance} and associations for those contents.  This
# ensures that when the {Metasploit::Model::Module::Ancestor#contents} are loaded in metasploit-framework, the same
# metadata instances are derived from the contents ensuring idempotency of the contents and metadata parsing loop.
class Metasploit::Model::Spec::Template < Metasploit::Model::Base
  extend ActiveSupport::Autoload
  extend ActiveModel::Callbacks

  include ActiveModel::Validations::Callbacks

  autoload :Write

  #
  # CONSTANTS
  #

  # Regular expression to parse file from backtrace line
  BACKTRACE_FILE_REGEXP = /(?<file>.*):\d+:in .*/
  # Trim mode for ERB templates so that lines using <%- -%> will be trimmed of new lines
  EXPLICIT_TRIM_MODE = '-'
  # File extension for templates.
  EXTENSION = '.rb.erb'

  #
  # Attributes
  #

  # @!attribute [rw] destination_pathname
  #   The pathname where to {#write} the template results.
  #
  #   @return [String]
  attr_accessor :destination_pathname

  # @!attribute [rw] locals
  #   Local variables to exposed to partials.
  #
  #   @return [Hash{Symbol => Object}]
  attr_accessor :locals

  # @!attribute [rw] overwrite
  #   Whether to overwrite a pre-existing file.
  #
  #   @return [Boolean]
  attr_accessor :overwrite

  # @!attribute [rw] search_pathnames
  #   Pathnames to search for partials.  First item is search first, etc.
  #
  #   @return [Array<Pathname>]
  attr_accessor :search_pathnames

  # @!attribute [rw] source_relative_name
  #   Name of template under {#search_pathnames} without {EXTENSION} similar to how to refer to partials.
  #
  #   @return [String]
  attr_accessor :source_relative_name


  #
  # Callbacks
  #

  before_validation :search_real_pathnames

  #
  # Validations
  #

  validates :destination_pathname,
            presence: true
  validates :overwrite,
            inclusion: {
                in: [
                    false,
                    true
                ]
            }
  validates :search_pathnames,
            length: {
                minimum: 1
            }
  validates :source_pathname,
            presence: true

  #
  # Methods
  #

  # Converts the `partial_relative_path` to a real (absolute) pathname that can be passed to {#result} by finding the
  # corresponding file in the {#search_pathnames}.
  #
  # @param partial_relative_path [String] partial path name as used in Rails, so no search_pathname prefix and no '_'
  #   or file extension in the basename.
  # @return (see #find_pathname)
  def partial_pathname(partial_relative_path)
    partial_relative_pathname = Pathname.new(partial_relative_path)
    relative_directory = partial_relative_pathname.dirname
    raw_basename = partial_relative_pathname.basename
    partial_basename = "_#{raw_basename}#{EXTENSION}"
    relative_pathname = relative_directory.join(partial_basename)

    find_pathname(relative_pathname)
  end

  # Renders partial in templates.
  #
  # @param partial_relative_path [String] relative path to partial without extension and no leading '_' to match
  #   Rails convention.
  # @param options (see #result)
  # @option (see #result)
  # @return [String, nil] result of rendering partial.
  def render(partial_relative_path, options={})
    pathname = partial_pathname(partial_relative_path)
    result(pathname, options)
  end

  # Renders the super template of the current template by searching for the template of the same name under super
  # {#search_pathnames} (those that have a higher index).
  #
  # @return [String, nil] result of rendering super partial.
  # @raise [IOError] if super template can't be found on super search pathnames.
  # @raise [RegexpError] if file can't be parsed from backtrace.
  def render_super
    super_pathname = nil
    backtrace = caller
    match = BACKTRACE_FILE_REGEXP.match(backtrace[0])

    if match
      real_path = match[:file]
      current_search_pathname_found = false
      relative_pathname = nil

      search_pathnames.each do |search_pathname|
        # find the current index
        unless current_search_pathname_found
          if real_path.starts_with?(search_pathname.to_path)
            current_search_pathname_found = true

            real_pathname = Pathname.new(real_path)
            relative_pathname = real_pathname.relative_path_from(search_pathname)
          end
          # then switch to finding the next (super) index
        else
          real_pathname = search_pathname.join(relative_pathname)

          if real_pathname.exist?
            super_pathname = real_pathname
            break
          end
        end
      end

      unless super_pathname
        raise IOError, "Couldn't find super template"
      end
    else
      raise RegexpError, "Can't parse file from backtrace to determine current search path"
    end

    result(super_pathname)
  end

  # @note Must be an instance method
  # @param pathname [Pathname] pathname to template
  # @param options [Hash{Symbol => Object}]
  # @option options [Hash{Symbol => Object}] :locals Maps name of locals to their value for this result.  Can override
  #   {#locals}.
  def result(pathname, options={})
    options.assert_valid_keys(:locals)

    if pathname
      content = pathname.read
      safe_level = nil
      template = ERB.new content, safe_level, EXPLICIT_TRIM_MODE
      template.filename = pathname.to_path

      erb_binding = binding.dup
      locals = self.locals || {}
      result_locals = options[:locals] || {}
      merged_locals = locals.merge(result_locals)

      merged_locals.each do |name, value|
        erb_binding.eval("#{name} = nil; lambda { |value| #{name} = value }").call(value)
      end

      # use current binding to allow templates to call {#render} and then use {#method_missing} to allow access to
      # locals
      template.result(erb_binding)
    else
      ''
    end
  end

  class << self
    # The root of all relative {#search_pathnames}.  By changing {root} you can use your own set of templates.
    #
    # @return [Pathname] Defaults to 'spec/support/templates/metasploit/model' under Metasploit::Model.root.
    def root
      @@root ||= Metasploit::Model::Engine.root.join('spec', 'support', 'templates', 'metasploit', 'model')
    end

    # Sets the {root} pathname for all {#search_pathnames}, including those on subclasses.
    #
    # @param root [Pathname]
    # @return [Pathname]
    def root=(root)
      @@root = root
    end
  end

  # Converts {#source_relative_name} to a real (absolute) pathname.
  #
  # @return (see #find_pathname)
  def source_pathname
    unless instance_variable_defined? :@source_pathname
      relative_path = "#{source_relative_name}#{EXTENSION}"
      @source_pathname = find_pathname(relative_path)
    end

    @source_pathname
  end

  # Writes result of template to {#destination_pathname}.
  #
  # @return [void]
  # @raise [Metasploit::Model::Spec::PathnameCollision] if {#overwrite} is false and {#destination_pathname} already
  #   exists.
  def write
    unless overwrite
      Metasploit::Model::Spec::PathnameCollision.check!(destination_pathname)
    end

    result = self.result(source_pathname)

    # make directory
    destination_pathname.parent.mkpath

    destination_pathname.open('wb') do |f|
      f.write(result)
    end
  end

  private

  # Finds relative_path under {#search_pathnames}
  #
  # @return [Pathname] if relative_path exists under a search path.
  # @return [nil] if `relative_path` does not exist under a search path.
  def find_pathname(relative_path)
    found_pathname = nil

    search_pathnames.each do |search_pathname|
      real_pathname = search_pathname.join(relative_path)

      if real_pathname.exist?
        found_pathname = real_pathname
        break
      end
    end

    found_pathname
  end

  # Makes sure all {#search_pathnames} are real (absolute).  Relative pathnames are resolved against {root}.
  #
  # @return [void]
  def search_real_pathnames
    search_pathnames.collect! { |search_pathname|
      if search_pathname.relative?
        self.class.root.join(search_pathname)
      else
        search_pathname
      end
    }
  end
end
