require 'skb'

module ResultFetcher
  ##
  # Runs mallodroid on an APK
  class Mallodroid_HEAD < Skb::ResultFetcher
    ## 
    # Timeout after 5 minutes
    def timeout 
      300
    end

    def execute
      @out.puts `mallodroid -x -f "#{@apk.path}"` 
      return true
    end
  end
end
