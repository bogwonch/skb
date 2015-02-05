require 'skb'
require 'tempfile'
require 'timeout'

module Skb
  ##
  # Generic class for implementing metadata fetching utilities
  class MetaFetcher < Fetcher
    ##
    # Result path is meta/FetcherName
    def results_path
      dir = 'meta'
      path = File.join(@apk_dir, dir, name)

      Dir.mkdir dir, 0744 \
        unless Dir.exist? dir

      File.expand_path path
    end
  end
end
