class Snail
  module Initializable
    def initialize(attrs = {})
      attrs.each do |k, v|
        m = "#{k}="
        raise UnknownAttribute, k unless respond_to? m
        send(m, v)
      end
      yield self if block_given?
    end
  end
end
