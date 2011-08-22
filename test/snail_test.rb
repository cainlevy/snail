require File.dirname(__FILE__) + '/test_helper'

class SnailTest < ActiveSupport::TestCase
  def setup
    @us = {:name => "John Doe", :line_1 => "12345 5th St", :city => "Somewheres", :state => "NY", :zip => "12345", :country => 'USA'}
    @ca = {:name => "John Doe", :line_1 => "12345 5th St", :city => "Somewheres", :state => "NY", :zip => "12345", :country => 'Canada'}
  end

  test "provides USPS country names" do
    assert Snail.const_defined?('USPS_COUNTRIES')
  end

  test "provides USA state names with abbreviations" do
    assert Snail.const_defined?('USA_STATES')
    assert_equal 'MN', Snail::USA_STATES['Minnesota']
  end

  test "USA states include territories and islands" do
    assert Snail::USA_STATES['Guam']
  end

  test "provides region codes via 2-digit iso country code" do
    assert_equal "WA", Snail::REGIONS[:us]["Washington"]
    assert_equal "WA", Snail::REGIONS[:au]["Western Australia"]
    assert_equal "BC", Snail::REGIONS[:ca]["British Columbia"]
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

  test "does not include country name for domestic addresses in canada" do
    Snail.home_country = "Canada"
    s = Snail.new(@ca)
    assert !s.to_s.match(/Canada/i)
    Snail.home_country = "USA"
  end

  test "includes country name for international addresses" do
    s = Snail.new(@ca)
    assert s.to_s.match(/Canada/i)
  end

  test "output ok if country is nil" do
    s = Snail.new(@ca.merge(:country => nil))
    assert s.to_s[-5,5] == "12345"
  end

  test "country names are uppercased" do
    s = Snail.new(@ca)
    assert s.to_s.match(/CANADA/)
  end

  test "empty lines are removed" do
    s = Snail.new(@us.merge(:line_1 => ""))
    assert !s.to_s.match(/^$/)
  end

  test "to_s" do
    s = Snail.new(@ca)
    assert_equal "John Doe\n12345 5th St\nSomewheres NY  12345\nCANADA", s.to_s
  end

  test "to_html" do
    s = Snail.new(@ca)
    s.name = 'John & Jane Doe'
    assert_equal "<address>John &amp; Jane Doe<br />12345 5th St<br />Somewheres NY  12345<br />CANADA</address>", s.to_html
    assert s.to_html.html_safe?
  end
end


