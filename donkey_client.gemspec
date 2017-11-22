
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'donkey_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'donkey_client'
  spec.version       = DonkeyClient::VERSION
  spec.authors       = ['CGTrader Developers']
  spec.email         = ['']

  spec.summary       = 'Donkey client gem'
  spec.description   = 'Donkey testing integration for CGTrader'
  spec.homepage      = 'http://donkey.cgtr.io'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://secret.cgtrader.gemhost'
  end
  spec.required_ruby_version     = '>= 2.5.0'
  spec.required_rubygems_version = '> 2.0'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'factory_bot'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
