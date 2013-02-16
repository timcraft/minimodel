Gem::Specification.new do |s|
  s.name = 'minimodel'
  s.version = '1.0.0'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Tim Craft']
  s.email = ['mail@timcraft.com']
  s.homepage = 'http://github.com/timcraft/minimodel'
  s.description = 'A little library for defining little models'
  s.summary = 'See description'
  s.files = Dir.glob('{lib,spec}/**/*') + %w(README.md Rakefile minimodel.gemspec)
  s.add_development_dependency('rake', '~> 10.0.3')
  s.add_development_dependency('activesupport', ['>= 3.0.3'])
  s.add_development_dependency('activerecord', ['>= 3.0.3'])
  s.add_development_dependency('sqlite3', ['~> 1.3.6'])
  s.require_path = 'lib'

  if RUBY_VERSION == '1.8.7'
    s.add_development_dependency('minitest', '>= 4.2.0')
    s.add_development_dependency('json', '>= 1.7.7')
  end
end
