require 'spec_helper'

describe Payback::Networks::Targetcircle do

  subject { Payback::Networks::Targetcircle }

  it "returns records" do
    VCR.use_cassette('targetcircle', tag: :targetcircle) do
      instance = subject.new
      records = instance.between('2017-11-01', '2017-11-02')
      records.first.tap do |record|
        record.uid.must_equal '12345'
        record.commission.must_equal 5.94
        record.epi.must_equal 'abc123'
        record.currency.must_equal 'EUR'
        assert_nil(record.channel)
        record.network.must_equal 'targetcircle'
        record.timestamp.must_equal Time.parse('2017-11-01 21:08:35 +0100')
        record.program.must_equal 'The Drunken Clam'
        record.clicked_at.must_equal Time.parse('2017-11-01 20:57:27 +0100')
        record.clicked_at.must_be :<, record.timestamp
      end
    end
  end

end
