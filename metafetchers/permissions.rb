require 'skb'

module MetaFetcher
  ##
  # Finds the Permissions of an APK
  class Permissions < Skb::MetadataFetcher
    def execute
      # Should probably check that aapt exists
      @out.puts `aapt dump permissions "#{@apk.path}"`
      return true
    end
  end
end
