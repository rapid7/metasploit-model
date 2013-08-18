module Metasploit
  module Model
    module Visitation
      # {ClassMethods#visit DSL} to declare {Metasploit::Model::Visitation::Visitor visitors} for a given `Module#name`
      # (or any Class that has an ancestor in `Class#ancestors` with that `Module#name`) and then use then to {#visit}
      # instances of those class and/or modules.
      module Visit
        extend ActiveSupport::Concern

        # Adds {#visit} DSL to class to declare {Metasploit::Model::Visitation::Visitor visitors}.
        module ClassMethods
          # Defines how to visit a node where `Module#name` is `:module_name`.
          #
          # @param options [Hash{Symbol => String}]
          # @option options [String] :module_name Name of class/module to be visited with block.
          # @yield [node] Block instance_exec'd on instance of the class {#visit} was called.
          # @yieldparam node [Object]
          # @raise [Metasploit::Model::Invalid] unless `block` is given.
          # @raise [Metasploit::Model::Invalid] unless :module_name is given.
          def visit(options={}, &block)
            options.assert_valid_keys(:module_name)

            visitor = Metasploit::Model::Visitation::Visitor.new(
                :module_name => options[:module_name],
                :parent => self,
                &block
            )
            visitor.valid!

            visitor_by_module_name[visitor.module_name] = visitor
          end

          # {Metasploit::Model::Visitation::Visitor Visitor} for `klass` or one of its `Class#ancestors`.
          #
          # @return [Metasploit::Model::Visitation::Visitor]
          # @raise [TypeError] if there is not visitor for `klass` or one of its ancestors.
          def visitor(klass)
            visitor = visitor_by_module[klass]

            unless visitor
              klass.ancestors.each do |mod|
                visitor = visitor_by_module[mod]

                unless visitor
                  visitor = visitor_by_module_name[mod.name]
                end

                if visitor
                  visitor_by_module[klass] = visitor

                  break
                end
              end
            end

            unless visitor
              raise TypeError,
                    "No visitor that handles #{klass} or " \
                    "any of its ancestors (#{klass.ancestors.map(&:name).to_sentence})"
            end

            visitor
          end

          # Allows {Metasploit::Model::Visitation::Visitor visitors} to be looked up by Module instead of `Module#name`.
          #
          # @return [Hash{Class => Metasploit::Model::Visitation::Visitor}]
          def visitor_by_module
            @visitor_by_module ||= {}
          end

          # Maps `Module#name` passed to {ClassMethods#visit} through :module_name to the
          # {Metasploit::Model::Visitation::Visitor} with the `Module#name` as
          # {Metasploit::Model::Visitation::Visitor#module_name}.
          #
          # @return [Hash{String => Metasploit::Model::Visitation::Visitor}]
          def visitor_by_module_name
            @visitor_by_module_name ||= {}
          end
        end

        #
        # Instance Methods
        #

        # Visits `node`
        #
        # @return (see Metasploit::Model::Visitation::Visitor#visit)
        def visit(node)
          visitor = self.class.visitor(node.class)

          visitor.visit(self, node)
        end
      end
    end
  end
end