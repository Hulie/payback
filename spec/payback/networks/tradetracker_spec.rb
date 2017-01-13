require 'spec_helper'

describe Payback::Networks::Tradetracker do

  subject { Payback::Networks::Tradetracker }

  it "returns records" do
    VCR.use_cassette('tradetracker', tag: :tradetracker) do
      instance = subject.new
      records = instance.between('2014-10-10', '2014-10-11')
      records.first.tap do |record|
        record.uid.must_equal ""
        record.commission.must_equal 0
        record.epi.must_equal ''
        record.currency.must_equal nil
        record.network.must_equal 'tradetracker'
        record.channel.must_equal ''
        record.timestamp.must_equal Time.parse('2014-10-10 00:13:05 CEST')
        record.program.must_equal ''
      end
    end
  end

end
