require 'skb'
require 'nokogiri'
require 'open-uri'

module MetaFetcher
  ##
  # Gets the review score from the PlayStore
  class PlayStoreReviewScore < Skb::MetaFetcher
    def execute
      begin
        doc = Nokogiri::HTML( \
          open("https://play.google.com/store/apps/details?id=#{@apk.package}", redirect: true))

        score = doc.css('div.score').text
        out << "#{score.to_f}"
        return true
      rescue Exception
        return false
      end
    end
  end
end
