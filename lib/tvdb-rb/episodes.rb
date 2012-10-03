module TVDB

  class Episodes

    def initialize episodes
      @episodes = episodes
    end

    def all
      episodes
    end

    def search_by_season_number season_number
      Episodes.new(episodes.select{|e| e.season_number == season_number} )
    end

    def search_by_guest_stars guest_stars
      Episodes.new(episodes.select{|e| e.guest_stars.include?(guest_stars) } )
    end

    def search_by_overview query_string
      Episodes.new(episodes.select{|e| e.overview.match(query_string) } )
    end

    def sort_by_rating
      episodes.sort_by{|e| e.rating }
    end

    private

    def episodes
      @episodes
    end

    def method_missing(sym, *args, &block)
      return episodes.send(sym, *args, &block) if episodes.respond_to?(sym)
      super(sym, *args, &block)
    end

  end

end