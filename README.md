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

# Authenticate
client.credentials # => [:api_key]
client.api_key = "<API_KEY>" # or fallbacks to ENV['TRADEDOUBLER_API_KEY']

# Get conversions for last 7 days
client.since(7) # => [<Conversion>,]

# Get conversions for given time period
client.between('2014-01-01', '2014-02-01') # => [<Conversion>,]

```

## Supported networks
- adrecord
- adservice
- adtraction
- cj
- double
- partner_ads
- tradedoubler
- tradetracker
- webgains
- zanox
- awin

## Conversion attributes
All attributes are not supported by some networks.

- uid
- epi
- commission
- currency (ISO 4217)
- network
- channel
- program
- status
- timestamp
- referrer
- clicked_at

## Contributing

1. Fork it ( https://github.com/[my-github-username]/payback/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
