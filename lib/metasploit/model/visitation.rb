module Metasploit
  module Model
    # Namespace for `metasploit-model`'s implementation of the {http://en.wikipedia.org/wiki/Visitor_pattern visitor
    # pattern}.
    module Visitation
      extend ActiveSupport::Autoload

      autoload :Visit
    end
  end
end