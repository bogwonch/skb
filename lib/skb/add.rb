require 'skb'

require 'rickshaw'
require 'mime-types'

module Skb
  class AddCommand < Skb::Command

    def execute
      @arguments.each do |argument|
        validate_apk(argument)
        add_apk(argument)
      end
    end

    private

    ##
    # Checks that +apk+ looks like an actual Android application
    #
    # Checks that +apk+ exists, isn't a directory and has the correct MIME
    # type.
    #
    # An ArgumentError is raised if +apk+ doesn't appear to be valid.
    def validate_apk(apk)
      unless File.exists? apk then
        raise ArgumentError, "The file '#{apk}' does not exist" 
      end

      if File.directory? apk then
        raise ArgumentError, "The file '#{apk}' is a directory"
      end

      mime = MIME::Types.of(apk).first.simplified
      unless mime == "application/vnd.android.package-archive"
        raise ArgumentError, "The file '#{apk} has the wrong MIME type: #{mime}"
      end
      
      return true
    end

    ##
    # Add +apk+ to the SKB
    def add_apk(apk)
      unless already_exists(apk)
        id = Skb::APK.get_id apk
        apk_dir = File.join(@options.location, id)
        
        # TODO: Drop permissions and set correct UID
        FileUtils.mkdir apk_dir, :mode => 0700
        FileUtils.cp apk, apk_dir
      else
        @log.warn "APK '#{apk}' already exists... skipping"
      end
    end

    ## 
    # Check whether +apk+ already exists.
    #
    # May throw exceptions if the file is there but something is wrong or we
    # have found a hash collision.
    def already_exists(apk)
      id = Skb::APK.get_id apk
      apk_dir = "#{@options.location}/#{id}"
      
      # Is the APK already present in the SKB?
      if File.directory? apk_dir then
        # Check if its the same apk
        apks = Dir["#{apk_dir}/*.apk"]
        if apks.length != 1 then
          raise SecurityError, "There is already an APK in the SKB with id '#{id}', but it seems odd. Please check SKB consistency."
        end

        unless Skb::APK.same(apk, apks.first) then
          raise NameError, "The apk '#{apk}' collides with an existing entry in the SKB with id: #{id}"
        end

        return true
      end

      return false
    end
  end
end
