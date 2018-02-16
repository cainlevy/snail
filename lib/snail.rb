# -*- encoding : utf-8 -*-
require 'snail/initializable'
require 'snail/constants'
require 'snail/helpers'

require 'cgi'
require 'active_support/core_ext/string/output_safety'

class Snail
  include Snail::Initializable

  # this will be raised whenever formatting or validation is run on an unsupported or unknown country
  class UnknownCountryError < ArgumentError; end
  # this will be raised whenever initialization doesn't recognize a key
  class UnknownAttribute < ArgumentError; end

  # Load the SnailHelpers module into ActionView::Base.  Previously this was done
  # automatically, but going forward it must be included explicitly by calling
  # Snail.load_helpers.
  def self.load_helpers
    return unless defined? ActionView
    warn '[DEPRECATION] Snail::Helpers will be removed in a future release.'
    ActionView::Base.class_eval { include Snail::Helpers }
  end

  def self.home_country
    @home_country ||= 'US'
  end

  def self.home_country=(val)
    @home_country = lookup_country_iso(val)
  end

  def self.lookup_country_iso(val)
    return if val.nil? || val.empty?
    val = val.upcase
    if ::Snail::Iso3166::ALPHA2[val]
      val
    else
      ::Snail::Iso3166::ALPHA2_EXCEPTIONS[val] || ::Snail::Iso3166::ALPHA3_TO_ALPHA2[val]
    end
  end

  # Snail's canonical fields
  attr_accessor :name
  alias full_name= name=

  attr_accessor :organization
  alias company= organization=

  attr_accessor :line_1
  alias street=   line_1=
  alias street_1= line_1=
  alias street1=  line_1=

  attr_accessor :line_2
  alias street_2= line_2=
  alias street2=  line_2=

  attr_accessor :city
  alias town=     city=
  alias locality= city=

  attr_accessor :region
  alias state=    region=
  alias province= region=

  attr_accessor :postal_code
  alias zip=      postal_code=
  alias zip_code= postal_code=
  alias postcode= postal_code=

  attr_reader   :country
  def country=(val)
    @country = Snail.lookup_country_iso(val)
  end

  # Where the mail is coming from.
  def origin=(val)
    @origin = Snail.lookup_country_iso(val)
  end

  # Where the mail is coming from. Defaults to the global `home_country`.
  def origin
    @origin ||= Snail.home_country
  end

  def international?
    country && origin != country
  end

  def to_s(with_country: nil)
    with_country = true if with_country.nil? && international?

    (
      recipient + [
        line_1,
        line_2,
        city_line,
        (country_line if with_country)
      ]
    )
      .reject { |line| line.nil? || line.empty? }
      .join("\n")
  end

  def to_html(with_country: nil)
    CGI.escapeHTML(to_s(with_country: with_country)).gsub("\n", '<br />').html_safe
  end

  # this method will get much larger. completeness is out of my scope at this time.
  # currently it's based on the sampling of city line formats from frank's compulsive guide.
  def city_line
    case country
    when 'CN', 'IN'
      "#{city}, #{region}  #{postal_code}"
    when 'BR'
      "#{postal_code} #{city}-#{region}"
    when 'MX', 'SK'
      "#{postal_code} #{city}, #{region}"
    when 'IT'
      "#{postal_code} #{city} #{region}"
    when 'BY'
      "#{postal_code} #{city}-#{region}"
    when 'US', 'CA', 'AU', nil, ''
      "#{city} #{region}  #{postal_code}"
    when 'IL', 'DK', 'FI', 'FR', 'DE', 'GR', 'NO', 'ES', 'SE', 'TR', 'CY', 'PT', 'MK', 'BA'
      "#{postal_code} #{city}"
    when 'KW', 'SY', 'OM', 'EE', 'LU', 'BE', 'IS', 'CH', 'AT', 'MD', 'ME', 'RS', 'BG', 'GE', 'PL', 'AM', 'HR', 'RO', 'AZ'
      "#{postal_code} #{city}"
    when 'NL'
      "#{postal_code}  #{city}"
    when 'IE'
      "#{city}, #{region}#{"\n" unless postal_code.nil? || postal_code.empty?}#{postal_code}"
    when 'GB', 'RU', 'UA', 'JO', 'LB', 'IR', 'SA', 'NZ'
      "#{city}  #{postal_code}" # Locally these may be on separate lines. The USPS prefers the city line above the country line, though.
    when 'EC'
      "#{postal_code} #{city}"
    when 'HK', 'IQ', 'YE', 'QA', 'AL'
      "#{city}"
    when 'AE'
      "#{postal_code}\n#{city}"
    when 'JP'
      "#{city}, #{region}\n#{postal_code}"
    when 'EG', 'ZA', 'IM', 'KZ', 'HU'
      "#{city}\n#{postal_code}"
    when 'LV'
      "#{city}, LV-#{postal_code}"
    when 'LT'
      "LT-#{postal_code} #{city}"
    when 'SI'
      "SI-#{postal_code} #{city}"
    when 'CZ'
      "#{postal_code} #{region}\n#{city}"
    else
      if Kernel.const_defined?('Rails')
        Rails.logger.error "[Snail] Unknown Country: #{country}"
      end
      "#{city} #{region}  #{postal_code}"
    end
  end

  def country_line
    (translated_country(origin, @country) || translated_country('US', @country))
  end

  def translated_country(origin, country)
    path = File.join(File.dirname(File.expand_path(__FILE__)), "../assets/#{origin}.yml")
    File.read(path).match(/^#{country}: (.*)$/)[1]
  end

  # NOTE: this is likely an incomplete list. please contribute!
  private def recipient
    case country
    when 'NL'
      [organization, name]
    else
      [name, organization]
    end
  end
end
