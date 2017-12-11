# DonkeyClient

Donkey A/B testing integration into CGTrader market

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'donkey_client', git: 'https://github.com/CGTrader/donkey_client'
```

And then execute:

    $ bundle
    
## Configuration
Requires (donkey_client/.env.sample -> project/.env) in the gem using project to test locally. `donkey_dashboard` application can be offline for testing purposes.

honeybadger/sentry can be used for connection errors if specified in initializer
```ruby
Donkey.configurate do |config|
  config.notifier :honeybadger, :notify

  # set experiments, alternatives and metrics
  config.configuration = {
      experiments: {
        sign_up_button_color: {
          name: 'Button color in sign up forms',
          alternatives:  {
            red:   {
              name: 'Red color'
            },
            green: {
              name: 'Light green. Color code: #6D803E'
            }
          },
          control_group: 'red'
        }
      },
      metrics:     {
        registration: {
          name: 'User creates an account'
        }
      }
    }
end
``` 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CGTrader/donkey_client.
