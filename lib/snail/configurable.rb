class Snail
  module Configurable
    def initialize(attrs = {}, &block)
      attrs.each do |k, v|
        m = "#{k}="
        if respond_to? m
          self.send(m, v)
        else
          raise UnknownAttribute.new(k)
        end
      end
      yield self if block_given?
    end
  end
  include Configurable
end
