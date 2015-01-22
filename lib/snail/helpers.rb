class Snail

  REGIONS = {
      # see http://en.wikipedia.org/wiki/Postcodes_in_Australia#Australia_States_and_territories
      :au => {
          'Australian Capital Territory' => 'ACT',
          'New South Wales' => 'NSW',
          'Victoria' => 'VIC',
          'Queensland' => 'QLD',
          'South Australia' => 'SA',
          'Western Australia' => 'WA',
          'Tasmania' => 'TAS',
          'Northern Territory' => 'NT'
      },
      # see http://en.wikipedia.org/wiki/Canadian_subnational_postal_abbreviations
      :ca => {
          'Alberta' => 'AB',
          'British Columbia' => 'BC',
          'Manitoba' => 'MB',
          'New Brunswick' => 'NB',
          'Newfoundland and Labrador' => 'NL',
          'Nova Scotia' => 'NS',
          'Northwest Territories' => 'NT',
          'Nunavut' => 'NU',
          'Ontario' => 'ON',
          'Prince Edward Island' => 'PE',
          'Quebec' => 'QC',
          'Saskatchewan' => 'SK',
          'Yukon' => 'YT'
      },
      # see http://www.columbia.edu/kermit/postal.html#usa
      # and http://www.usps.com/ncsc/lookups/usps_abbreviations.html
      :us => {
          'Alabama' => 'AL',
          'Alaska' => 'AK',
          'Arizona' => 'AZ',
          'Arkansas' => 'AR',
          'California' => 'CA',
          'Colorado' => 'CO',
          'Connecticut' => 'CT',
          'Delaware' => 'DE',
          'District Of Columbia' => 'DC',
          'Florida' => 'FL',
          'Georgia' => 'GA',
          'Hawaii' => 'HI',
          'Idaho' => 'ID',
          'Illinois' => 'IL',
          'Indiana' => 'IN',
          'Iowa' => 'IA',
          'Kansas' => 'KS',
          'Kentucky' => 'KY',
          'Louisiana' => 'LA',
          'Maine' => 'ME',
          'Maryland' => 'MD',
          'Massachusetts' => 'MA',
          'Michigan' => 'MI',
          'Minnesota' => 'MN',
          'Mississippi' => 'MS',
          'Missouri' => 'MO',
          'Montana' => 'MT',
          'Nebraska' => 'NE',
          'Nevada' => 'NV',
          'New Hampshire' => 'NH',
          'New Jersey' => 'NJ',
          'New Mexico' => 'NM',
          'New York' => 'NY',
          'North Carolina' => 'NC',
          'North Dakota' => 'ND',
          'Ohio' => 'OH',
          'Oklahoma' => 'OK',
          'Oregon' => 'OR',
          'Pennsylvania' => 'PA',
          'Rhode Island' => 'RI',
          'South Carolina' => 'SC',
          'South Dakota' => 'SD',
          'Tennessee' => 'TN',
          'Texas' => 'TX',
          'Utah' => 'UT',
          'Vermont' => 'VT',
          'Virginia' => 'VA',
          'Washington' => 'WA',
          'West Virginia' => 'WV',
          'Wisconsin' => 'WI',
          'Wyoming' => 'WY',

          # These are not states exactly, but they are addressed as states through USA
          'American Samoa' => 'AS',
          'Federated States Of Micronesia' => 'FM',
          'Guam' => 'GU',
          'Marshall Islands' => 'MH',
          'Northern Mariana Islands' => 'MP',
          'Palau' => 'PW',
          'Puerto Rico' => 'PR',
          'Virgin Islands' => 'VI',
          'Armed Forces Africa' => 'AE',
          'Armed Forces Americas (Except Canada)' => 'AA',
          'Armed Forces Canada' => 'AE',
          'Armed Forces Europe' => 'AE',
          'Armed Forces Middle East' => 'AE',
          'Armed Forces Pacific' => 'AP',
      },
      # http://en.wikipedia.org/wiki/Counties_of_Ireland
      # NB: only includes Replublic of Ireland, also no abbreviations
      :ie => {
          'Carlows' => 'Carlows',
          "Cavan" => 'Cavan',
          'Clare' => 'Clare',
          'Cork' => 'Cork',
          'Donegal' => 'Donegal',
          'Galway' => 'Galway',
          'Kerry' => 'Kerry',
          'Kildare' => 'Kildare',
          'Kilkenny' => 'Kilkenny',
          'Laois' => 'Laois',
          'Leitrim' => 'Leitrim',
          'Limerick' => 'Limerick',
          'Longford' => 'Longford',
          'Louth' => 'Louth',
          'Mayo' => 'Mayo',
          'Meath' => 'Meath',
          'Monaghan' => 'Monaghan',
          'Offaly' => 'Offaly',
          'Roscommon' => 'Roscommon',
          'Sligo' => 'Sligo',
          'Tipperary' => 'Tipperary',
          'Waterford' => 'Waterford',
          'Westmeath' => 'Westmeath',
          'Wexford' => 'Wexford',
          'Wicklow' => 'Wicklow',
      }
  }

  module Helpers

    def region_options_for_select(country = :us, selected = nil)
      options_for_select(REGIONS[country], selected)
    end

  end

end