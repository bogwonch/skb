require 'xdg'
require 'yaml'

module Skb
  class Config
    attr_reader :path
    attr_accessor :config

    def initialize(path=File.join(XDG['CONFIG_HOME'].to_s, 'skbrc.yaml'))
      @path = path
      @location = nil
      @config = {}

      if File.exists? @path then
        begin
          config = YAML.load_file @path
          @config = config['config']
        end
      end

      def location
        @config['location'] || ""
      end

    end
  end
end
