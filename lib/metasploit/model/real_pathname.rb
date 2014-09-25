require 'pathname'

# Adds {#real_pathname} to class, which will convert `#real_path` `String` to a `Pathname`.
module Metasploit::Model::RealPathname
  # `#real_path` as a `Pathname`.
  #
  # @return [Pathname] unless `#real_path` is `nil`.
  # @return [nil] if `#real_path` is `nil`.
  def real_pathname
    if real_path
      Pathname.new(real_path)
    else
      nil
    end
  end
end
