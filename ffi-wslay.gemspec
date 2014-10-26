$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'wslay/version'

Gem::Specification.new do |gem|
  gem.author       = 'Hendrik Beskow'
  gem.description  = 'Ruby ffi wslay wrapper'
  gem.summary      = gem.description
  gem.homepage     = 'https://github.com/Asmod4n/ruby-ffi-wslay'
  gem.license      = 'Apache-2.0'

  gem.name         = 'ffi-wslay'
  gem.files        = Dir['README.md', 'LICENSE', 'lib/**/*']
  gem.test_files   = Dir['spec/**/*']
  gem.version      = Wslay::VERSION

  gem.required_ruby_version = '>= 1.9.3'
  gem.add_dependency 'ffi', '>= 1.9.6'
  gem.add_dependency 'rake'
  gem.add_development_dependency 'rspec', '>= 3.1.0'
end
