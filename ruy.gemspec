Gem::Specification.new do |s|
  s.name        = 'ruy'
  s.version     = '0.2.1'
  s.date        = '2014-07-22'
  s.files       = Dir['lib/**/*']
  s.author      = 'Moove-IT'
  s.license     = 'MIT'
  s.summary     = 'Rules Engine for Ruby'
  s.homepage    = 'https://github.com/Moove-it/ruy'

  s.add_runtime_dependency 'tzinfo'

  s.add_development_dependency 'rspec', ['~> 3.1']
  s.add_development_dependency 'simplecov', '0.10.0'
end
