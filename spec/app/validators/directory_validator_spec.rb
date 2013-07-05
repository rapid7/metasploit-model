require 'spec_helper'

describe DirectoryValidator do
  subject(:directory_validator) do
    described_class.new(
        :attributes => attributes
    )
  end

  let(:attribute) do
    :directory
  end

  let(:attributes) do
    [
        attribute
    ]
  end

  context '#validate_each' do
    subject(:validate_each) do
      directory_validator.validate_each(record, attribute, value)
    end

    let(:record) do
      record_class.new
    end

    let(:record_class) do
      # capture for Class.new scope
      attribute = self.attribute

      Class.new do
        include ActiveModel::Validations

        #
        # Validations
        #

        validates attribute,
                  :directory => true
      end
    end

    context 'with value' do
      let(:error) do
        'must be a directory'
      end

      context 'with invalid path' do
        let(:value) do
          '/not/a/directory'
        end

        it 'should record error on attribute' do
          validate_each

          record.errors[attribute].should include(error)
        end
      end

      context 'with valid path' do
        let(:directory_pathname) do
          Metasploit::Model::Spec.temporary_pathname.join('directory')
        end

        before(:each) do
          directory_pathname.mkpath
        end

        context 'with file' do
          let(:file_pathname) do
            directory_pathname.join('file')
          end

          let(:value) do
            file_pathname.to_path
          end

          before(:each) do
            file_pathname.open('wb') do |f|
              f.puts 'A file'
            end
          end

          it 'should record error on attribute' do
            validate_each

            record.errors[attribute].should include(error)
          end
        end

        context 'with directory' do
          let(:value) do
            directory_pathname.to_path
          end

          it 'should not record any errors' do
            validate_each

            record.errors.should be_empty
          end
        end
      end
    end

    context 'without value' do
      let(:value) do
        nil
      end

      it 'should not record errors' do
        validate_each

        record.errors.should be_empty
      end
    end
  end
end