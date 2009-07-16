require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'test/unit'

ActiveSupport::Dependencies.load_paths << File.dirname(__FILE__) + '/../lib'

module Rails
  def self.logger
    @logger ||= Logger.new(StringIO.new)
  end
end