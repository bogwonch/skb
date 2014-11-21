require 'skb'
require 'nokogiri'
require 'open-uri'

module MetaFetcher
  ##
  # Gets the category from the PlayStore
  class PlayStoreCategory < Skb::MetaFetcher
    def execute
      begin
        doc = Nokogiri::HTML( \
          open("https://play.google.com/store/apps/details?id=#{@apk.package}", redirect: true))

        @out << doc.css('a.category').text.strip
        return true
      rescue Exception
        return false
      end
    end
  end
end
