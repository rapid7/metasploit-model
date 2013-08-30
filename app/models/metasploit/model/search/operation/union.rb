# A union of one or more {#children child operations} from an operator's `#operate_on`, should be visited the same as
# {Metasploit::Model::Search::Group::Base}.
class Metasploit::Model::Search::Operation::Union < Metasploit::Model::Search::Operation::Base
  #
  # Attributes
  #

  # @!attribute [rw] children
  #   Children operations of union.
  #
  #   @return [Array<Metasploit::Model::Search::Operation::Base>]
  attr_accessor :children

  #
  # Validations
  #

  validates :children,
            :length => {
                :minimum => 1
            }
end