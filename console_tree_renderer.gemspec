lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'console_tree_renderer/version'

Gem::Specification.new do |s|
  s.name        = 'console_tree_renderer'
  s.version     = ConsoleTreeRenderer::VERSION
  s.date        = '2020-01-23'
  s.summary     = 'Print tree-like objects with column-aligned attributes'
  s.description = 'Renders tree-like objects and column-aligned attributes for each tree node'
  s.authors     = ['Caseflow']
  s.email       = 'caseflowops@va.gov'
  s.homepage    = ''
  s.license     = ''

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  s.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.bindir        = 'exe'
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 1.17'
  s.add_development_dependency 'byebug' #, "~>0.3.0"
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_runtime_dependency 'tty-tree', '~>0.3.0'
end
