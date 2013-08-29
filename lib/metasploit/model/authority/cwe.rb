# Common Weakness Enumeration authority-specific code.
module Metasploit::Model::Authority::Cwe
  # Returns URL to {Metasploit::Model::Reference#designation the CWE ID's} page on mitre.org.
  #
  # @param designation [String] NNNN CWE ID.
  # @return [String] URL
  def self.designation_url(designation)
    "https://cwe.mitre.org/data/definitions/#{designation}.html"
  end
end
