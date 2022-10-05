# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metasploit/model/version'

Gem::Specification.new do |spec|
  spec.name          = 'metasploit-model'
  spec.version       = Metasploit::Model::VERSION
  spec.authors       = ['Metasploit Hackers']
  spec.email         = ['msfdev@metasploit.com']
  spec.description   = %q{Common code, such as validators and mixins, that are shared between ActiveModels in metasploit-framework and ActiveRecords in metasploit_data_models.}
  spec.summary       = %q{Metasploit Model Mixins and Validators}

  spec.files         = `git ls-files`.split($/).reject { |file|
    file =~ /^bin/
  }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w{app/models app/validators lib}

  spec.required_ruby_version = '>= 2.7.0'

  spec.add_development_dependency 'metasploit-yard'
  spec.add_development_dependency 'metasploit-erd'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'e2mmap'

  # Dependency loading

  spec.add_runtime_dependency 'activemodel', '~> 7.0'
  spec.add_runtime_dependency 'activesupport', '~> 7.0'

  spec.add_runtime_dependency 'railties', '~> 7.0'

  if RUBY_PLATFORM =~ /java/
    # markdown formatting for yard
    spec.add_development_dependency 'kramdown'

    spec.platform = Gem::Platform::JAVA
  else
    # markdown formatting for yard
    spec.add_development_dependency 'redcarpet'

    spec.platform = Gem::Platform::RUBY
  end
end
