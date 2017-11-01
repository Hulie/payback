require 'spec_helper'

describe Payback::Networks::Netbooster do

  subject { Payback::Networks::Netbooster }

  it "returns records" do
    VCR.use_cassette('netbooster', tag: :netbooster) do
      instance = subject.new
      records = instance.between('2017-11-01', '2017-11-01')
      records.first.tap do |record|
        record.uid.must_equal 'ca5b712a8f8552359f99e174'
        record.commission.must_equal 108.459227
        record.epi.must_equal 'epi123'
        record.currency.must_equal 'SEK'
        record.network.must_equal 'netbooster'
        record.channel.must_be_nil
        record.timestamp.must_equal Time.parse('2017-11-01 10:12:39')
        record.program.must_equal 'Kwik-E-Mart.com'
        record.status.must_equal 'Approved'
        record.clicked_at.must_equal Time.parse('2017-11-01 09:53:33')
        record.clicked_at.must_be :<, record.timestamp
      end
    end
  end

end
