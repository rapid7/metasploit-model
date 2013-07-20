FactoryGirl.define do
  #
  #
  # Metasploit::Model::Reference#designation sequences
  #
  #

  sequence :metasploit_model_reference_designation do |n|
    n.to_s
  end

  #
  # Mdm::Authority-specific Mdm::Reference#designation sequences
  #

  sequence :metasploit_model_reference_bid_designation do |n|
    n.to_s
  end

  sequence :metasploit_model_reference_cve_designation do |n|
    number = n % 10000
    year = n / 10000

    "%04d-%04d" % [year, number]
  end

  sequence :metasploit_model_reference_msb_designation do |n|
    number = n % 1000
    year = n / 1000

    "MS%02d-%03d" % [year, number]
  end

  sequence :metasploit_model_reference_osvdb_designation do |n|
    n.to_s
  end

  sequence :metasploit_model_reference_pmasa_designation do |n|
    number = n / 100
    year = n / 100

    "#{year}-#{number}"
  end

  sequence :metasploit_model_reference_secunia_designation do |n|
    n.to_s
  end

  sequence :metasploit_model_reference_us_cert_vu_designation do |n|
    n.to_s
  end

  sequence :metasploit_model_reference_waraxe_designation do |n|
    # numbers don't rollover on the year like other authorities
    year = n
    number = n

    "%d-SA#%d" % [year, number]
  end

  sequence :metasploit_model_reference_url do |n|
    "http://example.com/metasploit/model/reference/#{n}"
  end
end