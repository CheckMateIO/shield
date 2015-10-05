# Shield

Shield is a tool for managing your application's environment variables in a [Vault](https://vaultproject.io/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shield'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shield

## Setup
This gem assumes that you've already setup [Vault](https://vaultproject.io/).  You can use this gem on local vaults or ones that have been deployed to a server.  If you are working with a local server you'll just need to start vault and then proceed to the steps below. If you are working on a deployed vault you'll need to create an auth token for your vault and unseal it before you can interact with it using this gem.  That setup is out of the scope of this gem but is covered in the official Vault [documentation](https://vaultproject.io/docs/index.html).

1. `export VAULT_ADDR=YOUR_VAULT_SERVER_ADDRESS`
2. `export VAULT_TOKEN=YOUR_VAULT_AUTH_TOKEN`

## Usage
Shield will store environment variables as a hash of values based on your environment and the name of your app.  By default the environment is "development" but can be overriden with the `--environment` flag.  The name of your app is taken from your current working directory or by specifying it with the `--app` flag.

#### Add an environment variable
`shield add <key> <value>`

#### Update an environment variable
`shield update <key> <value>`

#### Remove an environment variable
`shield remove <key> <value>`

#### Fetch all environment variables and update your .env file
`shield fetch`

#### Environment Flag
By default, all commands use the "development" environment.  You can specify another enviroment with the `--environment` flag.

`shield fetch --environment=production` will fetch your production environment variables and update your `.env.production` file.

#### App flag
By default, all commands use your current working directory as the app name.  If for some reason you need to override this, you can do so with the `--app` flag.

`shield fetch --app=seabiscuit` will fetch the environment variables namespaced under the seabiscuit app.

#### .env files
Shield assumes you are using a tool like [dotenv](https://github.com/bkeepers/dotenv) or [Ember-cli-dotenv](https://github.com/fivetanley/ember-cli-dotenv) to load environment variables in your app as the `fetch` command will create/update the appropriate .env file.  For example, if pass the `--environment=production` flag, it'll update the `.env.production` file.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/shield.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

