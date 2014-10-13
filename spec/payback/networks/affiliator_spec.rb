require 'spec_helper'

describe Payback::Networks::Affiliator do

  subject { Payback::Networks::Affiliator }

  it "returns records" do
    VCR.use_cassette('affiliator', tag: :affiliator) do
      instance = subject.new
      records = instance.between('2012-09-17', '2012-09-18')
      records.first.tap do |record|
        record.uid.must_equal "12345"
        record.commission.must_equal "19.87"
        record.epi.must_equal 'abc123'
        record.currency.must_equal 'SEK'
        record.network.must_equal 'affiliator'
        record.channel.must_equal 'www.example.com'
        record.timestamp.to_s.must_equal '2012-09-18 20:41:40'
        record.program.must_equal 'Kwik-E-Mart'
        record.status.must_equal "1"
      end
    end
  end

end
