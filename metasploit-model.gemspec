# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metasploit/model/version'

Gem::Specification.new do |spec|
  spec.name          = 'metasploit-model'
  spec.version       = Metasploit::Model::GEM_VERSION
  spec.authors       = ['Luke Imhoff']
  spec.email         = ['luke_imhoff@rapid7.com']
  spec.description   = %q{Common code, such as validators and mixins, that are shared between ActiveModels in metasploit-framework and ActiveRecords in metasploit_data_models.}
  spec.summary       = %q{Metasploit Model Mixins and Validators}

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w{app/models app/validators lib}

  spec.required_ruby_version = '>= 2.1'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'metasploit-version', '~> 0.1.3'
  spec.add_development_dependency 'metasploit-yard', '~> 1.0'
  spec.add_development_dependency 'rake'

  # documentation
  # 0.8.7.4 has a bug where attribute setters show up as undocumented
  spec.add_development_dependency 'yard', '< 0.8.7.4'

  # Dependency loading
  rails_version_constraints = ['>= 4.0.9', '< 4.1.0']

  spec.add_runtime_dependency 'activemodel', *rails_version_constraints
  spec.add_runtime_dependency 'activesupport', *rails_version_constraints

  spec.add_runtime_dependency 'railties', *rails_version_constraints

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
