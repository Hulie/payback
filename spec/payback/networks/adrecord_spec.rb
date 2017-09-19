require 'spec_helper'

describe Payback::Networks::Adrecord do

  subject { Payback::Networks::Adrecord }

  it "returns records" do
    VCR.use_cassette('adrecord', tag: :adrecord) do
      instance = subject.new
      records = instance.between('2012-09-17', '2012-09-18')
      records.first.tap do |record|
        record.uid.must_equal 123456
        record.commission.must_equal 19.87
        record.epi.must_equal 'abc123'
        record.currency.must_equal nil
        record.network.must_equal 'adrecord'
        record.channel.must_equal 'example.com'
        record.timestamp.must_equal Time.parse('2012-09-17 18:00:51')
        record.program.must_equal 'Kwik-E-Mart'
        record.status.must_equal 5
        record.referrer.must_equal 'http://exempel.com/party.html'
        record.clicked_at.must_equal Time.parse('2012-09-17 17:57:06')
        record.clicked_at.must_be :<, record.timestamp
      end
    end
  end

end
