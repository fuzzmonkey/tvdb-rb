require 'restclient'
require 'nokogiri'
require 'cgi'

module TVDB

  class Client

    def initialize api_key
      @api_key = api_key
      @api_endpoint = "http://www.thetvdb.com/api/#{api_key}"
    end

    def get_series_by_id series_id, detailed_response
      xml = Nokogiri::XML RestClient.get("#{api_endpoint}/series/#{series_id}")
      Series.new(self, series_xml, detailed_response)
    end

    def get_episode_by_id episode_id, detailed_response
      xml = Nokogiri::XML RestClient.get("#{api_endpoint}/episodes/#{episode_id}")
      Episode.new(self, series_xml, detailed_response)
    end

    def get_series_by_name query, detailed_response
      escaped_query = CGI.escape(query)
      xml = Nokogiri::XML RestClient.get("http://www.thetvdb.com/api/GetSeries.php?seriesname=#{escaped_query}")
      series = []
      xml.xpath("Data/Series").each do |series_xml|
        series << Series.new(self, series_xml, detailed_response)
      end
      series
    end

    def api_endpoint
      @api_endpoint
    end

  end

end