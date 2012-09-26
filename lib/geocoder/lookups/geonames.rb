require 'geocoder/lookups/base'
require 'geocoder/results/geonames'

module Geocoder::Lookup
  class Geonames < Base
    @@method ||= :search

    METHODS = {
      :search => {
        :action => "search",
        :param => "name"
      }
    }

    def search(query, options = {})
      @@method = options.delete(:method)
      @@method = @@method.nil? ? :search : @@method.to_sym
      @@method = :search unless METHODS.has_key?(@@method)

      super(query, options)
    end

    def query_url(query)
      "http://api.geonames.org/#{METHODS[@@method][:action]}?" + url_query_string(query)
    end

    private # ---------------------------------------------------------------

    def results(query)
      return [] unless doc = fetch_data(query) 

      if !doc['status'].nil?
        warn "Geonames error: #{doc['status']['message']}"
        return []
      end

      return doc['totalResultsCount'] > 0 ? doc['geonames'] : []
    end

    def query_url_params(query)
      p = { }
      p[METHODS[@@method][:param]] = query
      super.merge(p).merge(:username => Geocoder::Configuration.username,
        :type => 'json', :lang => Geocoder::Configuration.language,
        :style => 'full')
    end
  end
end
