require 'spec_helper'

describe Payback::Networks::Webgains do

  subject { Payback::Networks::Webgains }

  it "returns records" do
    VCR.use_cassette('webgains', tag: :webgains) do
      instance = subject.new
      records = instance.between('2014-10-10', '2014-10-11')
      records.first.tap do |record|
        record.uid.must_equal "123456"
        record.commission.must_equal 19.87
        record.epi.must_equal 'abc123'
        record.currency.must_equal 'GBP'
        record.network.must_equal 'webgains'
        record.channel.must_equal 'example.com'
        record.timestamp.must_equal Time.parse('2014-10-10T11:02:48')
        record.program.must_equal 'Kwik-E-Mart'
        record.referrer.must_equal 'http://example.com/products'
        record.clicked_at.must_equal Time.parse('2014-10-10 10:26:59 +0200')
        record.clicked_at.must_be :<, record.timestamp
      end
    end
  end

end
