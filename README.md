# Payback

A ruby gem to retrieve conversions from affiliate networks.

## Installation

Add this line to your application's Gemfile:

    gem 'payback', github: 'voke/payback'

And then execute:

    $ bundle

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

## Conversion attributes
All attributes are not supported by some networks.

- UID
- EPI
- Commission
- Currency
- Network
- Channel
- Program
- Status
- Timestamp
- Referrer

## Contributing

1. Fork it ( https://github.com/[my-github-username]/payback/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
