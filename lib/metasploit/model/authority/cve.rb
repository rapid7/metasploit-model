# Common Vulnerabilities and Exposures authority-specific code.
module Metasploit::Model::Authority::Cve
  # Returns URL to {Metasploit::Model::Reference#designation the CVE ID's} page on CVE Details.
  #
  # @param designation [String] YYYY-NNNN CVE ID.
  # @return [String] URL
  def self.designation_url(designation)
    "http://cvedetails.com/cve/CVE-#{designation}"
  end
end
