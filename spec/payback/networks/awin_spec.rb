require 'spec_helper'

describe Payback::Networks::Awin do

  subject { Payback::Networks::Awin }

  it "returns records" do
    VCR.use_cassette('awin', tag: :awin) do
      instance = subject.new
      records = instance.between('2017-09-24', '2017-09-25')
      records.first.tap do |record|
        record.uid.must_equal 313683240
        record.commission.must_equal 65.28
        record.epi.must_equal 'abc123'
        record.currency.must_equal 'SEK'
        record.network.must_equal 'awin'
        record.channel.must_equal 'http://www.example.com'
        record.timestamp.must_equal Time.parse('2017-09-24 14:39:00')
        record.program.must_equal 12345
        record.status.must_equal 'pending'
        record.referrer.must_equal ''
        record.clicked_at.must_equal Time.parse('2017-09-24 14:39:00')
        record.clicked_at.must_be :<=, record.timestamp
      end
    end
  end

end
