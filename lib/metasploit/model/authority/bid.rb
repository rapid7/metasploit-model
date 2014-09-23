# BugTraq ID authority-specific code.
module Metasploit::Model::Authority::Bid
  # Returns URL to {Metasploit::Model::Reference#designation BugTraq ID's} page on SecurityFocus' site.
  #
  # @param designation [String] N+ BugTraq ID.
  # @return [String] URL
  def self.designation_url(designation)
    "http://www.securityfocus.com/bid/#{designation}"
  end
end
