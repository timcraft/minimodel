Gem::Specification.new do |s|
  s.name = 'minimodel'
  s.version = '2.0.0'
  s.license = 'LGPL-3.0'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Tim Craft']
  s.email = ['mail@timcraft.com']
  s.homepage = 'http://github.com/timcraft/minimodel'
  s.description = 'A little Ruby library for defining little models'
  s.summary = 'See description'
  s.files = Dir.glob('{lib,spec}/**/*') + %w(LICENSE.txt README.md Rakefile minimodel.gemspec)
  s.required_ruby_version = '>= 1.9.3'
  s.add_development_dependency('rake', '>= 12')
  s.add_development_dependency('activerecord', '~> 5')
  s.add_development_dependency('sqlite3', '~> 1.3')
  s.add_development_dependency('minitest', '~> 5')
  s.add_development_dependency('json', '~> 2')
  s.require_path = 'lib'
end
