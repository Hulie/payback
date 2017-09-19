require 'spec_helper'

describe Payback::Networks::Adservice do

  subject { Payback::Networks::Adservice }

  it "returns records" do
    VCR.use_cassette('adservice', tag: :adservice) do
      instance = subject.new
      records = instance.between('2017-08-20', '2017-08-31')
      records.first.tap do |record|
        record.uid.must_equal '123456789'
        record.commission.must_equal 75.0
        record.epi.must_equal 'abc123'
        record.currency.must_equal 'DKK'
        record.network.must_equal 'adservice'
        record.channel.must_equal 'example.com'
        record.timestamp.must_equal Time.parse('2017-08-23 19:45:48 +0200')
        record.program.must_equal 'Foobar.dk'
        record.status.must_equal 'approve'
        record.referrer.must_equal nil
        record.clicked_at.must_equal Time.parse('2017-08-23 19:41:21 +0200')
      end
    end
  end

end
