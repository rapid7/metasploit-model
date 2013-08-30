module Metasploit
  module Model
    # Error raised if a {Metasploit::Model} ActiveModel is invalid.
    class Invalid < Metasploit::Model::Error
      def initialize(model)
        @model = model

        errors = @model.errors.full_messages.join(', ')
        translated_message = I18n.translate('metasploit.model.invalid', :errors => errors)
        super(translated_message)
      end

      attr_reader :model
    end
  end
end