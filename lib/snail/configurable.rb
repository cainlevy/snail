class Snail
  class UnknownAttribute < ArgumentError; end

  module Configurable
    def initialize(options = {}, &block)
      options.each do |k, v|
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
