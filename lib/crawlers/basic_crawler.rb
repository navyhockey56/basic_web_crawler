module BasicCrawler
  class BasicCrawler
    include Crawler

    def create_source
      BasicSource.new(link: @uri, links_to: @links_to)
    end
  end

  class BasicSource
    include Crawler::Source
  end
end
