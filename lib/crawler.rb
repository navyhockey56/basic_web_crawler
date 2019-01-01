require 'crawler_tools'

module Crawler

  def Crawler.start_crawling(url:, max_sources:5, max_threads:1, crawler:)
    @@crawler = crawler
    @@max_sources = max_sources
    @@lock = Mutex.new
    @@number_active = 0
    @@max_threads = max_threads
    @@sources = []
    @@next_pages = [url]
    @@visited_pages = []
    @@stop_crawling = false

    puts 'Starting the crawl'
    while !@@stop_crawling
      puts 'Beggining another iteration'

      @@lock.synchronize {
        while @@number_active < @@max_threads && !@@next_pages.empty? 
          @@number_active += 1
          puts "Number Active: #{@@number_active}. Max Threads: #{@@max_threads}"
          Thread.new {
            begin 
              crawler = @@crawler.new @@next_pages.delete_at(0)
              crawler.open_page
              crawler.get_links_from_page
              source = crawler.create_source
              Crawler.add_source(source)
            rescue StandardError => ex
              puts "Dead Page Alert: #{ex}"
              Crawler.dead_page
            end  
          }
        end
      }
      @@stop_crawling ||= (@@number_active <= 0 && @@next_pages.empty?)
      sleep(1)
    end
    @@sources
  end

  def Crawler.add_source(source)
    @@lock.synchronize {
      @@sources << source 
      @@number_active += -1
      @@next_pages += source.links_to
      @@next_pages.uniq!
      @@visited_pages << source.link
      @@stop_crawling ||= @@sources.count >= @@max_sources
    }    
  end

  def Crawler.dead_page
    @@lock.synchronize {
      @@number_active += -1
    }
  end

  def Crawler.stop_crawling
    @@stop_crawling = true
  end

  attr_reader :uri, :page, :links_to

  def initialize(uri)
    @uri = uri
  end

  def open_page
    @page = CrawlerTools.open_page(@uri)
  end

  def get_links_from_page
    @links_to = CrawlerTools.scrape_links_on_page(@page)
  end

  def create_source
    raise 'Abstract Method Error'
  end

  module Source
    attr_reader :link, :links_to

    def initialize(link:, links_to:)
      @link = link
      @links_to = links_to
    end

    def inspect
      {
        link: @link,
        links_to: @links_to
      }
    end
  end
end
