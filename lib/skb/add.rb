require 'skb/command'
require 'skb'

require 'rickshaw'
require 'mime-types'

module Skb
  ##
  # Implements the command used by the CLI to add an app to the SKB
  class AddCommand < Skb::Command
    def execute
      @arguments.each do |argument|
        if File.directory? argument then add_dir argument
        else add_app argument end
      end
    end

    ##
    # Add a directory of apps to the SKB
    def add_dir(argument)
      Dir[File.join(argument, "*.apk")].each { |app| self.add_app app }
    end

    ##
    # Add an app to the SKB
    def add_app(argument)
      begin
        apk = Skb::APK.new(argument, @options)
        apk.add @options['location'], @log
        @log.info "added #{apk.path} with id #{apk.id}"
      rescue => e
        @log.error "#{e.message}"
        #puts e.backtrace
      end
    end
  end
end

