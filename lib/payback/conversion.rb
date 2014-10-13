module Payback
  class Conversion

    # UID
    # EPI
    # Commission
    # Currency
    # Network
    # Channel
    # Program
    # Status
    # Timestamp

    ATTRIBUTES = %w(uid epi commission currency network
      channel program status timestamp)

    attr_accessor *ATTRIBUTES

    def initialize(attrs = {})
      attrs.each do |key, value|
        public_send("#{key}=", value)
      end
    end

    def timestamp=(string)
      @timestamp = Time.parse(string) if string
    end

    def commission=(value)
      @commission = value.to_f if value
    end

    # TODO: Add GUID method?
    # def guid
    #   "#{network}-#{uid}"
    # end

    def attributes
      Hash[ATTRIBUTES.map { |key| [key, send(key)] }]
    end

    def valid?
      attributes.values.all? { |x| !x.to_s.strip.empty? }
    end

  end
end
