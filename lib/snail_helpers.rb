module SnailHelpers
  def usps_country_options_for_select(selected = nil, default_selected = 'USA')
    options_for_select(Snail::USPS_COUNTRIES, selected || default_selected)
  end

  def region_options_for_select(country = :us, selected = nil)
    options_for_select(Snail::REGIONS[country], selected)
  end

  # Deprecated
  def usa_state_options_for_select(selected = nil)
    region_options_for_select(:us, selected)
  end


end
