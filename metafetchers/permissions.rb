require 'skb'

module Metafetcher
  ##
  # Finds the Permissions of an APK
  class Permissions < Skb::MetadataFetcher
    def execute
      # Should probably check that aapt exists
      @out.puts `aapt dump permissions "#{@apk}"`
    end
  end
end
