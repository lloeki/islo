# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'islo/version'

Gem::Specification.new do |s|
  s.name        = 'islo'
  s.version     = Islo::VERSION
  s.authors     = ['Loic Nageleisen']
  s.email       = ['loic.nageleisen@gmail.com']
  s.homepage    = 'http://github.com/lloeki/islo'
  s.summary     = %q(Self-contained apps)
  s.description = <<-EOT
    Makes app completely self-contained by abstracting
    service process settings and execution
  EOT
  s.license     = 'MIT'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n")
                                           .map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'rainbow', '~> 2.0'
  s.add_dependency 'slop'

  s.add_development_dependency 'rspec', '~> 2.14'
  s.add_development_dependency 'rake', '~> 10.3'
  s.add_development_dependency 'pry'
end
