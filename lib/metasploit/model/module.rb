# Namespace that maps to `Mdm::Module` and `Metasploit::Framework::Module` and contains constants and mixins to
# DRY the implementation of the in-memory and in-database models in those namespaces.
module Metasploit::Model::Module
  extend ActiveSupport::Autoload

  autoload :Action
  autoload :Ancestor
  autoload :Architecture
  autoload :Author
  autoload :Class
  autoload :Handler
  autoload :Instance
  autoload :Path
  autoload :Platform
  autoload :Rank
  autoload :Reference
  autoload :Stance
  autoload :Target
  autoload :Type
end
