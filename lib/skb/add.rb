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
          apk = Skb::APK.new(argument)
          apk.add @options.location, @log
          @log.info "added #{apk.path} with id #{apk.id}"
        rescue Exception => e
          @log.error "#{e.message}"
        end
      end
    end
  end
end
