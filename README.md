# GemMiner

[![Gem Version](https://badge.fury.io/rb/gem-miner.svg)](https://badge.fury.io/rb/gem-miner)
[![Build Status](https://travis-ci.org/reevoo/gem-miner.svg?branch=master)](https://travis-ci.org/reevoo/gem-miner)
[![Code Climate](https://codeclimate.com/github/reevoo/gem-miner/badges/gpa.svg)](https://codeclimate.com/github/reevoo/gem-miner)



At [Reevoo](http://reevoo.github.io), we want to get rid of some of our old repositories - they don't do anything and they're confusing new starters. However, we want to make sure that these repositories aren't used by others.

GemMiner looks through all of the repositories of a GitHub user and shows where a gem is being used by extracting information from Gemfiles and Gemspecs.

This tool is being actively developed; please feel free to contribute or fork for your own purposes!

## Installation

This is a tool, so it makes sense to install it globally.

```bash
gem install 'gem-miner'
```

## Usage

Execute `gem-miner help` in your favourite shell for information on the wonderful things this application can do.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/reevoo/gem-miner.
