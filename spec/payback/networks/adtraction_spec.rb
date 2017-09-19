require 'spec_helper'

describe Payback::Networks::Adtraction do

  subject { Payback::Networks::Adtraction }

  it "returns records" do
    VCR.use_cassette('adtraction', tag: :adtraction) do
      instance = subject.new
      records = instance.between('2012-09-17', '2012-09-18')
      records.first.tap do |record|
        record.uid.must_equal 123456
        record.commission.must_equal 19.87
        record.epi.must_equal 'abc123'
        record.currency.must_equal 'SEK'
        record.network.must_equal 'adtraction'
        record.channel.must_equal 'example.com'
        record.timestamp.must_equal Time.parse('2012-09-18T11:42:30+0200')
        record.program.must_equal 'Kwik-E-Mart'
        record.referrer.must_equal 'http://www.example.com/ads'
        record.clicked_at.must_equal Time.parse('2012-09-18 11:38:07 +0200')
        record.clicked_at.must_be :<, record.timestamp
      end
    end
  end

end
