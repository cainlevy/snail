require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'test/unit'

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'snail'

module Rails
  def self.logger
    @logger ||= Logger.new(StringIO.new)
  end
end
