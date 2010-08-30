require 'snail/configurable'
require 'snail/constants'
require 'snail_helpers'

class Snail
  include Configurable
  
  # this will be raised whenever formatting or validation is run on an unsupported or unknown country
  class UnknownCountryError < ArgumentError; end
  
  # My made-up standard fields.
  attr_accessor :name
  attr_accessor :line_1
  attr_accessor :line_2
  attr_accessor :city
  attr_accessor :region
  attr_accessor :postal_code
  attr_accessor :country
  
  # Aliases for easier assignment compatibility
  {
    :full_name  => :name,
    :street     => :line_1,
    :town       => :city,
    :state      => :region,
    :province   => :region,
    :zip        => :postal_code,
    :zip_code   => :postal_code,
    :postcode   => :postal_code
  }.each do |new, existing|
    alias_method "#{new}=", "#{existing}="
  end

  def self.home_country
    @home_country ||= "USA"
  end

  def self.home_country=(val)
    @home_country = val
  end
  
  def to_s
    [name, line_1, line_2, city_line, country_line].select{|line| !(line.nil? or line.empty?)}.join("\n")
  end
  
  def to_html 
    "<address>#{to_s.gsub("\n", '<br />')}</address>"
  end
  
  # this method will get much larger. completeness is out of my scope at this time.
  # currently it's based on the sampling of city line formats from frank's compulsive guide.
  def city_line
    case country
    when 'China', 'India'
      "#{city}, #{region}  #{postal_code}"
    when 'Brazil'
      "#{postal_code} #{city}-#{region}"
    when 'Mexico', 'Slovakia'
      "#{postal_code} #{city}, #{region}"
    when 'Italy'
      "#{postal_code} #{city} (#{region})"
    when 'Belarus'
      "#{postal_code} #{city}-(#{region})"
    when 'USA', 'Canada', 'Australia', nil, ""
      "#{city} #{region}  #{postal_code}"
    when 'Israel', 'Denmark', 'Finland', 'France', 'Germany', 'Greece', 'Italy', 'Norway', 'Spain', 'Sweden', 'Turkey', 'Cyprus', 'Portugal', 'Macedonia', 'Bosnia and Herzegovina'
      "#{postal_code} #{city}"
    when 'Kuwait', 'Syria', 'Oman', 'Estonia','Luxembourg', 'Belgium', 'Iceland', 'Switzerland', 'Austria', 'Moldova', 'Montenegro', 'Serbia', 'Bulgaria', 'Georgia', 'Poland', 'Armenia', 'Croatia', 'Romania', 'Azerbaijan'
      "#{postal_code} #{city}"
    when 'Netherlands'
      "#{postal_code} #{region} #{city}"
    when 'Ireland'
      "#{city}, #{region}"
    when 'England', 'Scotland', 'Wales', 'United Kingdom', 'Russia', 'Russian Federation', 'Ukraine', 'Jordan', 'Lebanon','Iran, Islamic Republic of', 'Iran', 'Saudi Arabia', 'New Zealand'
      "#{city}  #{postal_code}" # Locally these may be on separate lines. The USPS prefers the city line above the country line, though.
    when 'Ecuador'
      "#{postal_code} #{city}"
    when 'Hong Kong', 'Syria', 'Iraq', 'Yemen', 'Qatar', 'Albania'
      "#{city}"
    when 'United Arab Emirates'
      "#{postal_code}\n#{city}"
    when 'Japan'
      "#{city}, #{region}\n#{postal_code}"
    when 'Egypt', 'South Africa','Isle of Man', 'Kazakhstan', 'Hungary'
      "#{city}\n#{postal_code}"
    when 'Latvia'
      "#{city}, LV-#{postal_code}"
    when 'Lithuania'
      "LT-#{postal_code} #{city}"
    when 'Slovenia'
      "SI-#{postal_code} #{city}"
    when 'Czech Republic'
      "#{postal_code} #{region}\n#{city}"
    else
      if Kernel.const_defined?("Rails")
        Rails.logger.error "[Snail] Unknown Country: #{country}"
      end
      "#{city} #{region}  #{postal_code}"
    end
  end
  
  def country_line
    self.class.home_country.to_s.upcase == country.to_s.upcase ? nil : country.to_s.upcase
  end
end
