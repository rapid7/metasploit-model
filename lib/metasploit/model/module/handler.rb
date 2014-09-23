# The handler Module for a {Metasploit::Model::Module::Ancestor#handled?} {Metasploit::Model::Module::Ancestor}.
module Metasploit::Model::Module::Handler
  #
  # CONSTANTS
  #

  # Maps {TYPES} to {GENERAL_TYPES} used as connection types for `Msf::Payload`.
  GENERAL_TYPE_BY_TYPE = {
      'bind_tcp' => 'bind',
      'find_port' => 'find',
      'find_shell' => 'find',
      'find_tag' => 'find',
      'none' => 'none',
      'reverse_http' => 'tunnel',
      'reverse_https' => 'tunnel',
      'reverse_https_proxy' => 'tunnel',
      'reverse_ipv6_http' => 'tunnel',
      'reverse_ipv6_https' => 'tunnel',
      'reverse_tcp' => 'reverse',
      'reverse_tcp_allports' => 'reverse',
      'reverse_tcp_double' => 'reverse',
      'reverse_tcp_double_ssl' => 'reverse',
      'reverse_tcp_ssl' => 'reverse'
  }
  # General handler types that are used as connection types for Msf::Payloads.
  GENERAL_TYPES = GENERAL_TYPE_BY_TYPE.values.uniq.sort
  # Types of handlers
  TYPES = GENERAL_TYPE_BY_TYPE.keys.sort
end
