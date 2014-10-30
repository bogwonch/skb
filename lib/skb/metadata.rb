require 'skb'
require 'tempfile'
require 'timeout'

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

        out = nil
        unless File.exist? @results_path
          begin
            @out = Tempfile.new class_name

            # Run the Fetcher
            # TODO: Drop privileges
            okay = Timeout::timeout(self.timeout()) { execute }

            if okay
              out = File.open(@results_path, 'a+')
              @out.rewind
              out << @out.gets
            end
          ensure
            @out.close unless @out.nil?
            out.close unless out.nil?
          end
        end
      end

      Process.wait
    end

    def execute
      fail NotImplementedError,
           'attempted to call MetadataFetcher execute'
    end

    def timeout
      nil
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
