# GitMiner

Pet project I build experimenting with different concepts.

GitMiner allow for "mining" of vanity git prefixes.

This gem is a work in progress (core functionality is working).


## Installation

Installation will add the `git-mine` binary.

```ruby
gem 'git_miner'
```


## Usage

Though `git`, using `git mine [DESIRED_PREFIX]` will invoke the required logic.

Eg.:
```
git mine c0ffee
```

Some extra options are available. `git-mine -h` will display the help section (default options are optimised for performance).
