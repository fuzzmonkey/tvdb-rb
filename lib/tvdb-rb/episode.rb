module TVDB

  class Episode

    attr_accessor :tvdb_id, :episode_name, :episode_number, :first_aired, :guest_stars, :imdb_id, :language, :overview, :rating, :rating_count, :production_code, :season_number, :writers, :series_id, :director

    def initialize client, xml
      @client = client
      # @raw_rsp = xml
      @tvdb_id  = xml.xpath("id").text
      @episode_name = xml.xpath("EpisodeName").text
      @episode_number = xml.xpath("EpisodeNumber").text
      @first_aired = xml.xpath("FirstAired").text
      @guest_stars = to_array xml.xpath("GuestStars").text
      @imbdb_id = xml.xpath("IMDB_ID").text
      @language = xml.xpath("Language").text
      @overview = xml.xpath("Overview").text
      @production_code = xml.xpath("ProductionCode").text
      @rating = xml.xpath("Rating").text
      @rating_count = xml.xpath("RatingCount").text
      @season_number = xml.xpath("SeasonNumber").text
      @writers = to_array xml.xpath("Writer").text
      @directors = to_array xml.xpath("Director").text
      @season_id = xml.xpath("seasonid").text
      @series_id = xml.xpath("seriesid").text
    end

    def to_array string
      string.split("|").reject! { |c| c.empty? }
    end

  end

end