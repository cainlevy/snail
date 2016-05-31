require File.dirname(__FILE__) + '/test_helper'

class SnailTest < Snail::TestCase
  def setup
    @us = {:name => "John Doe", :line_1 => "12345 5th St", :city => "Somewheres", :state => "NY", :zip => "12345", :country => 'USA'}
    @ca = {:name => "John Doe", :line_1 => "12345 5th St", :city => "Somewheres", :state => "NY", :zip => "12345", :country => 'CAN'}
    @ie = {:name => "John Doe", :line_1 => "12345 5th St", :city => "Somewheres", :region => "Dublin", :zip => "12345", :country => 'IE'}
  end

  test "provides region codes via 2-digit iso country code" do
    assert_equal "WA", Snail::REGIONS[:us]["Washington"]
    assert_equal "WA", Snail::REGIONS[:au]["Western Australia"]
    assert_equal "BC", Snail::REGIONS[:ca]["British Columbia"]
    assert_equal "Cork", Snail::REGIONS[:ie]["Cork"]
  end

  ##
  ## Configuration
  ##

  test "initializes from a hash" do
    s = Snail.new(:name => "John Doe", :city => "Somewheres")
    assert_equal 'John Doe', s.name
    assert_equal 'Somewheres', s.city
  end

  test "aliases common street names" do
    assert_equal Snail.new(:street_1 => "123 Foo St").line_1, Snail.new(:line_1 => "123 Foo St").line_1
  end

  test "aliases common city synonyms" do
    assert_equal Snail.new(:town => "Somewheres").city, Snail.new(:city => "Somewheres").city
    assert_equal Snail.new(:locality => "Somewheres").city, Snail.new(:city => "Somewheres").city
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
  ## Country Normalization
  ##

  test "normalize alpha3 to alpha2" do
    s = Snail.new(@ca.merge(:country => 'SVN'))
    assert_equal "SI", s.country
  end

  test "normalize alpha2 exceptions to alpha2" do
    s = Snail.new(@ca.merge(:country => 'UK'))
    assert_equal "GB", s.country
  end

  test "leave alpha2 as alpha2" do
    s = Snail.new(@ca.merge(:country => 'GB'))
    assert_equal "GB", s.country
  end

  ##
  ## Formatting
  ##

  test "includes two spaces between region and zip for domestic mail" do
    s = Snail.new(@us)
    assert s.city_line.match(/NY  12345/)
  end

  test "does not include country name for domestic addresses" do
    s = Snail.new(@us.merge(:origin => 'US'))
    assert !s.to_s.match(/United States/i)
    s = Snail.new(@ca.merge(:origin => 'CA'))
    assert !s.to_s.match(/Canada/i)
  end

  test "includes country name for domestic addresses if the country parameter is present" do
    s = Snail.new(@us.merge(:origin => 'US'))
    assert s.to_s(country: true).match(/United States/i)
    s = Snail.new(@ca.merge(:origin => 'CA'))
    assert s.to_s(country: true).match(/Canada/i)
  end

  test "includes country name for international addresses" do
    s = Snail.new(@us.merge(:origin => 'CA'))
    assert s.to_s.match(/United States/i)
    s = Snail.new(@ca.merge(:origin => 'US'))
    assert s.to_s.match(/Canada/i)
  end

  test "includes country name for international addresses if the country parameter is present" do
    s = Snail.new(@us.merge(:origin => 'CA'))
    assert s.to_s(country: true).match(/United States/i)
    s = Snail.new(@ca.merge(:origin => 'US'))
    assert s.to_s(country: true).match(/Canada/i)
  end

  test "includes translated country name for international addresses" do
    s = Snail.new(@us.merge(:origin => 'FR'))
    assert s.to_s.match(/ÉTATS-UNIS/i)
    s = Snail.new(@ca.merge(:origin => 'EC'))
    assert s.to_s.match(/CANADÁ/i)
  end

  test "includes first country name for countries with many commonly used names" do
    s = Snail.new(@ca.merge(:country => 'UK'))
    assert s.to_s.match(/United Kingdom\Z/i), s.to_s
  end

  test "output ok if country is nil" do
    s = Snail.new(@ca.merge(:country => nil))
    assert s.to_s[-5,5] == "12345"
  end

  test "country names are uppercased" do
    s = Snail.new(@ca)
    assert s.to_s.match(/CANADA/), s.to_s
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
    assert_equal "John &amp; Jane Doe<br />12345 5th St<br />Somewheres NY  12345<br />CANADA", s.to_html
    assert s.to_html.html_safe?
  end
end


