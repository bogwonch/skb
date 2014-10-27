require 'skb'

module Skb
  ##
  # Generic class for implementing metadata fetching utilities
  class MetadataFetcher
    attr_reader :apk, :out, :results_path

    def initialize(apk_dir)
      class_name = self.class.name.split('::').last
      @results_path = File.expand_path File.join(apk_dir, 'meta', class_name)

      _pid = Process.fork do
        Dir.chdir apk_dir
        @apk = APK.new find_apk

        Dir.mkdir 'meta', 0744 unless Dir.exist? 'meta'

        unless File.exist? @results_path
          @out = File.open(@results_path, 'a+')

          # Run the Fetcher
          # TODO: Drop privileges
          execute

          @out.close
        end
      end

      Process.wait
    end

    def execute
      fail NotImplementedError,
           'attempted to call MetadataFetcher execute'
    end

    def to_s
      raise "No results for '#{self.class.name.split('::').last}'" \
        unless File.exist? @results_path

      out = ""
      File.open(@results_path, 'r') do |f|
        while (line = f.gets)
          out << line
        end
      end
      
      return out
    end

    private

    ##
    # Locate the APK the fetcher needs to use
    def find_apk
      apks = Dir['*.apk']

      fail "wrong number of APKs in #{apk_dir}: " \
           "#{apks.length} instead of 1" \
        unless apks.length == 1

      apks.first
    end
  end
end
