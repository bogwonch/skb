require 'skb'

module MetaFetcher
  ##
  # Finds the Permissions of an APK
  class Name < Skb::MetaFetcher
    def execute
      @out.puts "#{@apk.package}"
      return true
    end
  end
end
