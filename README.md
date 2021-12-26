# GitMiner

Pet project I built to experiment with different concepts.

GitMiner allow "mining" of vanity Git SHA1 prefixes.

The HEAD commit is altered via variations over committer and author timestamp adjustments. Other commit metadata such as commit message or description are left as their original.


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

These will add the `git-mine` binary which act as a Git custom command: `git mine`.


## Usage

`git mine [DESIRED_PREFIX]` will amend the current HEAD commit with a new mined SHA.

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
