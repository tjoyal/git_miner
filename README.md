# GitMiner

Pet project I built to experiment with different concepts.

GitMiner allow "mining" of vanity Git SHA1 prefixes.

This gem is a work in progress (core functionality is working).


## Installation

Rubygem:
```ruby
gem 'git_miner'
```

Development:
```
gem build git_miner.gemspec
gem install --local git_miner-*.gem 
```

The installation will add the `git-mine` binary which act as a Git custom command: `git mine`.


## Usage

Though `git`, using `git mine [DESIRED_PREFIX]` will invoke the required logic.

Eg.:
```
git mine c0ffee
```

Some extra options are available (experimental):
```
$ git-mine -h
Usage: example.rb [options]
        --engine [ruby|c]            Set the engine (default: ruby)
        --dispatch [simple|parallel] Set the dispatch (default: parallel)
    -h, --help                       Show this message
```
