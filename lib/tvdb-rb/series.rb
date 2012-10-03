module TVDB

  class Series

    attr_accessor :series_id
    attr_accessor :language
    attr_accessor :series_name
    attr_accessor :banner
    attr_accessor :overview
    attr_accessor :first_aired
    attr_accessor :imdb_id
    attr_accessor :tvdb_id
    # detailed response
    attr_accessor :genres
    attr_accessor :actors
    attr_accessor :rating
    attr_accessor :rating_count

    def initialize client, xml, detailed_response
      @client = client
      # @raw_rsp = xml
      @series_id = xml.xpath("seriesid").text
      @language = xml.xpath("language").text
      @series_name = xml.xpath("SeriesName").text
      @banner = xml.xpath("banner").text
      @overview = xml.xpath("Overview").text
      @first_aired = xml.xpath("FirstAired").text #Date.parse?
      @imdb_id = xml.xpath("IMDB_ID").text
      @tvdb_id = xml.xpath("id").text
      @api_url = "#{client.api_endpoint}/series/#{series_id}"
      load_detail if detailed_response
    end

    def load_detail
      xml = Nokogiri::XML RestClient.get @api_url
      root = xml.xpath("Data/Series")
      @genres = to_array root.xpath("Genre").text
      @actors = to_array root.xpath("Actors").text
      @rating = root.xpath("Rating").text
      @rating_count = root.xpath("RatingCount").text
    end

    def get_episodes
      xml = Nokogiri::XML RestClient.get "#{@api_url}/all"
      episode_array = []
      xml.xpath("//Episode").each do |episode_xml|
        episode_array << Episode.new(@client, episode_xml)
      end
      Episodes.new(episode_array)
    end

    def get_episode season_number, episode_number
      episodes.find{|e| e.episode_number == episode_number && e.season_number == season_number }
    end

    def episodes
      @episodes ||= get_episodes
    end

    def to_array string
      string.split("|").reject! { |c| c.empty? }
    end

  end

end