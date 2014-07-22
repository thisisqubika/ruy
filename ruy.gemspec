Gem::Specification.new do |s|
  s.name        = 'Ruy'
  s.version     = '0.0.1'
  s.date        = '2014-06-04'
  s.files       = Dir['lib/**/*']
  s.author      = 'Moove-IT'
  s.license     = 'MIT'
  s.summary     = 'Rule Engine for Ruby'

  s.add_development_dependency 'rspec', ['>= 3.0.0']
  s.add_development_dependency 'sequel', ['>= 4.12.0']
end
