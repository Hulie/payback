require 'spec_helper'

describe Payback::Networks::Double do

  subject { Payback::Networks::Double }

  it "returns records" do
    VCR.use_cassette('double', tag: :double) do
      instance = subject.new
      records = instance.between('2014-01-07', '2014-01-08')
      records.first.tap do |record|
        record.uid.must_equal 123456
        record.commission.must_equal 19.87
        record.epi.must_equal 'abc123'
        record.currency.must_equal 'SEK'
        record.network.must_equal 'double'
        record.channel.must_equal 'example.com'
        record.timestamp.must_equal Time.parse('2014-01-07T12:00:12.862Z')
        record.program.must_equal 'Kwik-E-Mart'
        record.status.must_equal 'allowed'
        record.clicked_at.must_be_nil
      end
    end
  end

end
