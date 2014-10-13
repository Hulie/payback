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
      @timestamp = string ? Time.parse(string) : nil
    end

    def commission=(value)
      @commission = value ? value.to_f : nil
    end

    # TODO: Add GUID method?
    # def guid
    #   "#{network}-#{uid}"
    # end

    def attributes
      Hash[ATTRIBUTES.map { |key| [key, send(key)] }]
    end

  end
end
