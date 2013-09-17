FactoryGirl.define do
  sequence :metasploit_model_module_class_payload_type, Metasploit::Model::Module::Class::PAYLOAD_TYPES.cycle

  trait :metasploit_model_module_class do
    #
    # Attributes
    #

    # Don't set full_name: before_validation will derive it from {Metasploit::Model::Module::Class#module_type} and
    # {Metasploit::Model::Module::Class::reference_name}.

    ignore do
      # derives from associations in instance, so don't set on instance
      module_type { generate :metasploit_model_module_type }

      # depends on module_type
      # ignored because model attribute will derived from reference_name, this factory attribute is used to generate
      # the correct reference_name.
      payload_type {
        # module_type is factory attribute, not model attribute
        if module_type == Metasploit::Model::Module::Type::PAYLOAD
          generate :metasploit_model_module_class_payload_type
        else
          nil
        end
      }
    end

    after(:build) do |module_class|
      if module_class.rank
        module_class.ancestors.each do |ancestor|
          real_path = ancestor.derived_real_path

          if real_path
            backup_real_path = "#{real_path}.bak"
            FileUtils.mv(real_path, backup_real_path)

            File.open(backup_real_path, 'rb') do |backup_file|
              lines = backup_file.readlines
              # everything before the closing end
              before = lines[0 ... -1]

              # the closing end
              after = lines[-1 .. -1]

              File.open(real_path, 'wb') do |f|
                before.each do |line|
                  f.puts line
                end

                # if there is another method already leave a blank line
                if before[-1] == 'end'
                  f.puts ''
                end

                f.puts "  def self.rank_name"
                f.puts "    #{module_class.rank.name.inspect}"
                f.puts "  end"
                f.puts ''
                f.puts "  def self.rank_number"
                f.puts "    #{module_class.rank.number}"
                f.puts "  end"

                after.each do |line|
                  f.puts line
                end
              end
            end

            File.delete(backup_real_path)
          end
        end
      end
    end
  end
end