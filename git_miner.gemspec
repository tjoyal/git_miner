
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "git_miner/version"

Gem::Specification.new do |spec|
  spec.name          = "git_miner"
  spec.version       = GitMiner::VERSION
  spec.authors       = ["Thierry Joyal"]
  spec.email         = ["thierry.joyal@gmail.com"]

  spec.summary       = "git-mine shell executable"
  spec.description   = "git-mine provide mining logic for Git sha prefix"
  spec.homepage      = "https://github.com/tjoyal/git_miner"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/tjoyal/git_miner"
    # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = "bin"
  spec.executables   = ["git-mine"]
  spec.require_paths = ["lib"]

  spec.extensions = Dir["ext/**/extconf.rb"]

  spec.add_runtime_dependency "parallel", "~> 1.17"
  spec.add_runtime_dependency "concurrent-ruby", "~> 1.1"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake-compiler", "~> 1.0"
end
