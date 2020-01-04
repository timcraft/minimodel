Gem::Specification.new do |s|
  s.name = 'minimodel'
  s.version = '2.0.0'
  s.license = 'LGPL-3.0'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Tim Craft']
  s.email = ['mail@timcraft.com']
  s.homepage = 'https://github.com/timcraft/minimodel'
  s.description = 'A little Ruby library for defining little models'
  s.summary = 'See description'
  s.files = Dir.glob('{lib,spec}/**/*') + %w(LICENSE.txt README.md Rakefile minimodel.gemspec)
  s.required_ruby_version = '>= 1.9.3'
  s.require_path = 'lib'
end
