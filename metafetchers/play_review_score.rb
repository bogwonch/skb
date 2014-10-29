require 'skb'
require 'nokogiri'
require 'open-uri'

module MetaFetcher
  ##
  # Gets the review score from the PlayStore
  class PlayStoreReviewScore < Skb::MetadataFetcher
    def execute
      begin
        doc = Nokogiri::HTML( \
          open("https://play.google.com/store/apps/details?id=#{@apk.package}", redirect: true))

        score = doc.css('div.score').text
        out << "#{score.to_f}"
      rescue Exception
        out << "0.0"
      end
    end
  end
end
