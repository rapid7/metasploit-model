# Extend to add a class method to create a new template and write it only if valid.
#
# @example extend and write
#   class MyTemplate
#     extend Metasploit::Model::Spec::Template::Write
#
#     def write
#       ...
#     end
#   end
#
#   success = MyTemplate.write(attributes)
module Metasploit::Model::Spec::Template::Write
  # Writes template for `attributes` to disk if the created template is valid.
  #
  # @return [true] if template was valid and was written.
  # @return [false] if template was invalid and was not written.
  def write(attributes={})
    template = new(attributes)

    written = template.valid?

    if written
      template.write
    end

    written
  end
end