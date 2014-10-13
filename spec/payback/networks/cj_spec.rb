require 'spec_helper'

describe Payback::Networks::Cj do

  subject { Payback::Networks::Cj }

  it "returns records" do
    VCR.use_cassette('cj', tag: :cj) do
      instance = subject.new
      records = instance.between('2012-09-17', '2012-09-18')
      records.first.tap do |record|
        record.uid.must_equal "123456"
        record.commission.must_equal "19.87"
        record.epi.must_equal 'abc123'
        record.currency.must_equal nil
        record.network.must_equal 'cj'
        record.channel.must_equal '555'
        record.timestamp.must_equal '2012-09-17T01:51:07-0700'
        record.program.must_equal 'Kwik-E-Mart'
      end
    end
  end

end
