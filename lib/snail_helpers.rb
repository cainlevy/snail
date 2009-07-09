module SnailHelpers
  def usps_country_options_for_select(selected = nil, default_selected = 'USA')
    options_for_select(Snail::USPS_COUNTRIES, selected || default_selected)
  end
  
  def usa_state_options_for_select(selected = nil)
    options_for_select(Snail::USA_STATES, selected)
  end
end
