# Payback

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'payback', github: 'voke/payback'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install payback

## Usage

```ruby
# Get supported networks
Payback.networks

# Instantiate network client
client = Payback(:tradedoubler)

# Get conversions for last 7 days
client.since(7)

# Get conversions for given time period
client.between('2014-01-01', '2014-02-01')

```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/payback/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
