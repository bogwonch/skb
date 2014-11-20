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
        begin
          apk = Skb::APK.new(argument, @options)
          apk.add @options['location'], @log
          @log.info "added #{apk.path} with id #{apk.id}"
        rescue => e
          @log.error "#{e.message}"
          puts e.backtrace
        end
      end
    end
  end
end

