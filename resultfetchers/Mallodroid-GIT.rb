require 'skb'

module ResultFetcher
  ##
  # Runs mallodroid on an APK
  class Mallodroid_GIT < Skb::ResultFetcher
    def version 
      "git" 
    end

    def execute
      @out.puts `mallodroid -f "#{@apk.path}"` 
    end
  end
end
