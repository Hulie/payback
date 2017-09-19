require 'spec_helper'

describe Payback::Networks::Tradetracker do

  subject { Payback::Networks::Tradetracker }

  it "returns records" do
    VCR.use_cassette('tradetracker', tag: :tradetracker) do
      instance = subject.new
      records = instance.between('2014-10-10', '2014-10-11')
      records.first.tap do |record|
        record.uid.must_equal "123456789"
        record.commission.must_equal 21.392
        record.epi.must_equal ''
        record.currency.must_equal 'SEK'
        record.network.must_equal 'tradetracker'
        record.channel.must_equal 'example.com'
        record.timestamp.must_equal Time.parse('2014-10-10 10:18:34 +0200')
        record.program.must_equal 'foobar.com'
        record.clicked_at.must_equal Time.parse('2014-10-10 10:13:55 +0200')
      end
    end
  end

end
