# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metasploit/model/version'

Gem::Specification.new do |spec|
  spec.name          = 'metasploit-model'
  spec.version       = Metasploit::Model::VERSION
  spec.authors       = ['Luke Imhoff']
  spec.email         = ['luke_imhoff@rapid7.com']
  spec.description   = %q{Common code, such as validators and mixins, that are shared between ActiveModels in metasploit-framework and ActiveRecords in metasploit_data_models.}
  spec.summary       = %q{Metasploit Model Mixins and Validators}

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'

  # documentation
  spec.add_development_dependency 'yard'

  spec.add_runtime_dependency 'activerecord', '>= 3.2.13'
  spec.add_runtime_dependency 'activesupport'

  if RUBY_PLATFORM =~ /java/
    # markdown formatting for yard
    spec.add_development_dependency 'kramdown'

    spec.add_runtime_dependency 'jdbc-postgres'
    spec.add_runtime_dependency 'activerecord-jdbcpostgresql-adapter'

    spec.platform = Gem::Platform::JAVA
  else
    # markdown formatting for yard
    spec.add_development_dependency 'redcarpet'

    spec.add_runtime_dependency 'pg'

    spec.platform = Gem::Platform::RUBY
  end
end
