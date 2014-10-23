require 'logger'

module Skb
  class Command
    attr_reader :options, :arguments, :log

    def initialize(options, arguments, log=nil)
      @options   = options
      @arguments = arguments

      unless log.nil?
        @log = log
      else
        @log = ::Logger.new(STDOUT)
        @log.level = Logger::WARN
      end
    end

  end
end
