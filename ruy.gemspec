Gem::Specification.new do |s|
  s.name        = 'ruy'
  s.version     = '0.0.1'
  s.date        = '2014-06-04'
  s.files       = Dir['lib/**/*']
  s.author      = 'Moove-IT'
  s.license     = 'MIT'
  s.summary     = 'Rules Engine for Ruby'
  s.homepage    = 'https://github.com/Moove-it/ruy'

  s.add_development_dependency 'rspec', ['>= 3.0.0']
  s.add_development_dependency 'sequel', ['>= 4.12.0']
end
