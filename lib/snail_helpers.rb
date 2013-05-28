module SnailHelpers

  def region_options_for_select(country = :us, selected = nil)
    options_for_select(Snail::REGIONS[country], selected)
  end

end
