require File.dirname(__FILE__) + '/test_helper'

class SnailTest < ActiveSupport::TestCase
  def setup
    @us = {:name => "John Doe", :street => "12345 5th St", :city => "Somewheres", :state => "NY", :zip => "12345", :country => 'United States'}
    @ca = {:name => "John Doe", :street => "12345 5th St", :city => "Somewheres", :state => "NY", :zip => "12345", :country => 'Canada'}
  end

  test "provides USPS country names" do
    assert false, "pending"
  end

  ##
  ## Configuration
  ##
  
  test "initializes from a hash" do
    s = Snail.new(:name => "John Doe", :city => "Somewheres")
    assert_equal 'John Doe', s.name
    assert_equal 'Somewheres', s.city
  end
  
  test "aliases common city synonyms" do
    assert_equal Snail.new(:town => "Somewheres").city, Snail.new(:city => "Somewheres").city
  end
  
  test "aliases common region synonyms" do
    assert_equal Snail.new(:state => "Somewheres").region, Snail.new(:region => "Somewheres").region
    assert_equal Snail.new(:province => "Somewheres").region, Snail.new(:region => "Somewheres").region
  end
  
  test "aliases common postal code synonyms" do
    assert_equal Snail.new(:zip => "12345").postal_code, Snail.new(:postal_code => "12345").postal_code
    assert_equal Snail.new(:zip_code => "12345").postal_code, Snail.new(:postal_code => "12345").postal_code
    assert_equal Snail.new(:postcode => "12345").postal_code, Snail.new(:postal_code => "12345").postal_code
  end
  
  ##
  ## Formatting
  ##
  
  test "includes two spaces between region and zip for domestic mail" do
    s = Snail.new(@us)
    assert /NY  12345/, s.city_line
  end
  
  test "does not include country name for domestic addresses" do
    s = Snail.new(@us)
    assert !s.to_s.match(/United States/i)
  end
  
  test "includes country name for international addresses" do
    s = Snail.new(@ca)
    assert s.to_s.match(/Canada/i)
  end
  
  test "country names are uppercased" do
    s = Snail.new(@ca)
    assert s.to_s.match(/CANADA/)
  end
end
