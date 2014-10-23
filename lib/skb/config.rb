require 'xdg'
require 'yaml'

module Skb
  ##
  # Class for accessing SKB config files and their values
  class Config
    attr_reader :path
    attr_accessor :config

    def initialize(path = File.join(XDG['CONFIG_HOME'].to_s, 'skbrc.yaml'))
      @path = path
      @location = nil
      @config = {}

      return unless File.exist? @path

      config = YAML.load_file @path
      @config = config['config']
    end

    ##
    # Getter for location data
    def location
      @config['location'] || ''
    end
  end
end
