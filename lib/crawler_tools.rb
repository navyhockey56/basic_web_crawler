require 'nokogiri'

module CrawlerTools
    
  def CrawlerTools.scrape_links_on_page(page)
    page.css("a[href^='http']").map { |ele|
      ele.attributes['href'].value rescue nil
    }.compact
  end

  def CrawlerTools.scrape_text_on_page(page)
    page.inner_text
  end

  def CrawlerTools.scrape_images_on_page(page)
    image_containers = page.xpath("//img")
    images = image_containers.map { |container|
      container.attributes['src'].value rescue nil
    }.compact
    
    # Find the other images container in hrefs
    images += page.css("[href]").map { |ele|
      ele.attributes['href'].value rescue nil
    }.select { |ref|
      ref =~ /(\.jpg)|(\.png)/
    }

    # There are still other images that have not been identified...

    # Return the found images
    images.uniq
  end

  def CrawlerTools.scrape_videos_on_page(page)

  end

  def CrawlerTools.scrape_audios_on_page(page)

  end

  def CrawlerTools.scrape_pdfs_on_page(page)

  end

  def CrawlerTools.open_page(uri)
    # Parse the uri
    uri = URI.parse(uri)
    # Get the page
    r = Net::HTTP.get_response(uri)
    # Convert the page to a nokogiri document
    Nokogiri.HTML(r.body)
  end

end