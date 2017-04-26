# JWTGen [![Build Status](https://travis-ci.org/shhavel/jwtgen.svg?branch=master)](https://travis-ci.org/shhavel/jwtgen)

CLI for generating Json Web Tokens (JWT's)

CLI takes multiple key value pairs as input, and copy the generated JWT to your clipboard.

Required inputs are user_id and email. In addition, other key/value pairs can also be entered.

## Installation

    $ gem install jwtgen

## Dependencies

Check dependencies of [Ruby Clipboard](https://github.com/janlelis/clipboard/)

## Usage

Basic usage without encryption:

    $ jwtgen user_id 1234 email ted.crilly@example.com
    The JWT has been copied to your clipboard!

Provide HMAC algorithm and secret key:

    $ jwtgen --key my$ecretK3y --algorithm HS512 \
        user_id 1234 \
        email dougal.mcguire@example.com \
        name "Dougal McGuire" \
        role Manager
    The JWT has been copied to your clipboard!

You can store options `key` and `algorithm` in configuration file `.jwtgen` stored in your user folder

    --key 2f27090cf62f34c1dcfd4b1de3809bb8b1ab31f0b376d1cf8c36827f4d5ad2dd
    --algorithm HS512

NOTE: Supplied options have a higher priority than options stored in the configuration file.

Create file with single cammand (don't forget to replace the key):

    $ echo "--key 2f27090cf62f34c1dcfd4b1de3809bb8b1ab31f0b376d1cf8c36827f4d5ad2dd\n--algorithm HS512" > ~/.jwtgen

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shhavel/jwtgen.

## Uninstall

To uninstall gem and remove executables run `gem uninstall jwtgen`
