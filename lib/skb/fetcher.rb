require 'skb'
require 'tempfile'
require 'timeout'

module Skb
  ##
  # Generic class for implementing tools that fetch data
  class Fetcher
    attr_reader :apk, :out

    def initialize(apk_dir, options = nil, overwrite: false)
      @apk_dir = File.expand_path apk_dir
      @options = options

      # Forking so we can later drop privileges
      _pid = Process.fork do
        Dir.chdir apk_dir # TODO: check path exists and chdir succeeds

        @apk = APK.new find_apk_path

        results = nil
        if overwrite || !(File.exist? results_path)
          begin
            # Temporary output file
            @out = Tempfile.new name

            # Run the fetcher
            # TODO: drop privileges
            okay = Timeout::timeout(timeout) { execute }

            # If everything ran okay then copy the tempfile to the results file
            if okay
              results = File.open results_path, 'w'
              @out.rewind
              results << @out.read
            end
          ensure
            @out.close unless @out.nil?
            results.close unless results.nil?
          end
        end

      end
      Process.wait
    end

    ##
    # Path to the results
    #
    # Should create directory tree if it doesn't already exist
    #
    # This should be overwritten by derived classes
    def results_path
      fail NotImplementedError
    end

    ##
    # Command to fetch the data
    def execute
      fail NotImplementedError
    end

    ##
    # Timeout for the fetcher to retrieve the information in seconds
    def timeout
      nil
    end

    ##
    # Gets the name of the current class
    def name
      self.class.name.split('::').last
    end

    ##
    # Locate the APK the fetcer needs to use
    def find_apk_path
      apks = Dir['*.apk']
      fail "wrong number of APKs in #{apk_dir}: " \
           "#{apks.length} instead of 1" \
        unless apks.length == 1

      apks.first
    end

    ##
    # Convert the fetcher to a string. Typically the results
    def to_s
      fail "No results for '#{self.class.name.split('::').last}'" \
        unless File.exist? results_path

      out = ''
      File.open(results_path, 'r') do |f|
        while (line = f.gets)
          out << line
        end
      end
      out
    end
  end
end
