# GitMiner

Pet project I built to experiment with different concepts.

GitMiner allow "mining" of vanity Git SHA1 prefixes.

The HEAD commit is altered via variations over committer and author timestamp adjustments. Other commit metadata such as commit message or description are left as their original.


## Installation

These options will add the `git-mine` binary which act as a Git custom command: `git mine`.

### Rubygem

```ruby
gem 'git_miner'
```

### Manual

```
gem build git_miner.gemspec
gem install --local git_miner-*.gem 
```

## Usage

`git mine [DESIRED_PREFIX]` will amend the current HEAD commit with a new mined SHA.

Eg.:
```
git mine c0ffee
```

Some extra options are available (experimental):
```
$ git mine -h
Usage: git mine [options]
        --engine [ruby|c]            Set the engine (default: ruby)
        --dispatch [simple|parallel] Set the dispatch (default: parallel)
        --verbose                    Run verbosely (default: false)
        --register [prefix]          Register automated post commit git hook
    -v, --version                    Returns the current version
    -h, --help                       Show this message
```


### Development

```
[path]/git_miner/bin/git-mine ...
```
