require 'geocoder/results/base'

module Geocoder::Result
  class Geonames < Base

    ##
    # A string in the given format.
    #
    def address(format = :full)
      nil
    end

    ##
    # A two-element array: [lat, lon].
    #
    def coordinates
      [@data['lat'].to_f, @data['lng'].to_f]
    end

    def latitude
      coordinates[0]
    end

    def longitude
      coordinates[1]
    end

    def state
      @data['adminName1']
    end

    def province
      state
    end

    def state_code
      @data['adminCode1']
    end

    def province_code
      state_code
    end

    def country
      @data['countryName']
    end

    def country_code
      @data['countryCode']
    end

    def city
      @data['name'].gsub(/\s+\d+.*/, '')
    end

    def postal_code
    end

    def self.response_attributes
      %w[adminCode3 adminCode2 alternateNames adminCode1 score lng north
        adminCode5 adminCode4 adminName2 fcodeName adminName3 timezone
        adminName4 adminName5 bbox name east fcode geonameId lat population
        adminName1 fclName countryCode toponymName fcl continentCode south west]
    end

    response_attributes.each do |a|
      define_method a do
        @data[a]
      end
    end
  end
end
