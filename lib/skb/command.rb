require 'logger'

module Skb
  ##
  # General class for CLI commands
  class Command
    attr_reader :options, :arguments, :log

    def initialize(options, arguments, log = nil)
      @options   = options
      @arguments = arguments

      if log.nil?
        @log = ::Logger.new(STDOUT)
        @log.level = Logger::WARN
      else
        @log = log
      end
    end
  end
end
