require 'spec_helper'

describe Payback::Networks::Tradedoubler do

  subject { Payback::Networks::Tradedoubler }

  it "returns records" do
    VCR.use_cassette('tradedoubler', tag: :tradedoubler) do
      instance = subject.new
      records = instance.between('2014-10-10', '2014-10-11')
      records.first.tap do |record|
        record.uid.must_equal "123456-654321"
        record.commission.must_equal "19.87"
        record.epi.must_equal 'abc123'
        record.currency.must_equal nil
        record.network.must_equal 'tradedoubler'
        record.channel.must_equal 'example.com'
        record.timestamp.must_equal Time.parse('2014-10-10 00:09:40 CEST')
        record.program.must_equal 'Kwik-E-Mart'
      end
    end
  end

end
