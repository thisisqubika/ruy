Gem::Specification.new do |s|
  s.name        = 'ruy'
  s.version     = '0.2.1'
  s.date        = '2014-07-22'
  s.files       = %w(LICENSE README.md) + Dir['lib/**/*']
  s.author      = 'Moove-IT'
  s.license     = 'MIT'
  s.summary     = 'Rules Engine for Ruby'
  s.description = 'A library for defining a set of conditions, matching them against an input,' \
                  ' and finally return an outcome.'
  s.homepage    = 'http://moove-it.github.io/ruy/'
  s.email       = 'ruy@moove-it.com'

  s.add_runtime_dependency 'tzinfo', '~> 1'

  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_development_dependency 'simplecov', '0.10.0'
end
