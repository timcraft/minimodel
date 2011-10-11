Gem::Specification.new do |s|
  s.name = 'minimodel'
  s.version = '0.2.0'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Tim Craft']
  s.email = ['mail@timcraft.com']
  s.homepage = 'http://github.com/timcraft/minimodel'
  s.description = 'A little library for defining little models'
  s.summary = 'See description'
  s.files = Dir.glob('{lib,spec}/**/*') + %w(README.txt Rakefile minimodel.gemspec)
  s.add_development_dependency('activesupport', ['>= 3.0.3'])
  s.add_development_dependency('activerecord', ['>= 3.0.3'])
  s.require_path = 'lib'
end
