require 'skb'

require 'rickshaw'
require 'mime-types'

module Skb
  ##
  # Implements the command used by the CLI to add an app to the SKB
  class AddCommand < Skb::Command
    def execute
      @arguments.each do |argument|
        apk = Skb::APK.new(argument)
        apk.add @options.location, @log
        @log.info "added #{apk.path} with id #{apk.id}"
      end
    end
  end
end
