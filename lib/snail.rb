class Snail
  include Configurable
  
  # My made-up standard fields.
  attr_accessor :name
  attr_accessor :institution
  attr_accessor :street
  attr_accessor :city
  attr_accessor :region
  attr_accessor :postal_code
  attr_accessor :country
  
  # Aliases for easier assignment compatibility
  {
    :full_name  => :name,
    :company    => :institution,
    :business   => :institution,
    :line_1     => :street,
    :town       => :city,
    :state      => :region,
    :province   => :region,
    :zip        => :postal_code,
    :zip_code   => :postal_code,
    :postcode   => :postal_code
  }.each do |new, existing|
    alias_method "#{new}=", "#{existing}="
  end
  
  def to_s
    [name, institution, street, city_line, country_line].compact.join("\n")
  end
  
  def city_line
    case country
    when 'China', 'India'
      "#{city}, #{region} #{postal_code}"
    when 'Brazil'
      "#{postal_code} #{city}-#{region}"
    when 'Mexico'
      "#{postal_code} #{city}, #{region}"
    when 'Italy'
      "#{postal_code} #{city} (#{region})"
    when 'United States', 'Canada', 'Australia', nil, ""
      "#{city} #{region}  #{postal_code}"
    else
      raise "unknown country: #{country}"
    end
  end
  
  def country_line
    country.upcase unless country == 'United States'
  end
end
