module ImageCrawler
  class ImageCrawler
    include Crawler

    def create_source
      ImageSource.new.new(
        link: @uri, 
        links_to: @links_to,
        images: CrawlerTools.scrape_images_on_page(@page))
    end

  end

  class ImageSource
    include Crawler::Source

    attr_reader :images

    def initialize(link:, links_to:, images:)
      super(link, links_to)
      @images = images
    end

  end
end