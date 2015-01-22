require 'rubygems'
require 'minitest/autorun'

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'snail'

class Snail::TestCase < Minitest::Test
  def self.test(str, &block)
    name = "test_" + str.gsub(/[^a-z_]/, '_').gsub(/_{2,}/, '_')
    define_method name, &block
  end
end
