require 'ipaddr'

# Validates that value is a valid IPv4 or IPv6 address.
class IpFormatValidator < ActiveModel::EachValidator
  # Validates that `attribute`'s `value` on `object` is a valid IPv4 or IPv6 address.
  #
  # @param record [#errors, ApplicationRecord] ActiveModel or ActiveRecord
  # @param attribute [Symbol] name of IP address attribute.
  # @param value [String, nil] IP address.
  # @return [void]
  def validate_each(object, attribute, value)
    error_message_block = lambda{ object.errors.add attribute, "must be a valid IPv4 or IPv6 address" }
    begin
      if value.is_a? IPAddr
        potential_ip = value.dup
      else
        potential_ip = IPAddr.new(value)
      end

      error_message_block.call unless potential_ip.ipv4? || potential_ip.ipv6?
    rescue ArgumentError
      error_message_block.call
    end
  end
end
