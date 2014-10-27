module Skb
  ##
  # Generic class for implementing app checking utilities
  class ResultFetcher
    attr_reader :apk, :out

    def initialize(apk_dir)
      class_name = self.class.name.split('::').last
      dir_path = File.expand_path File.join(apk_dir, 'results', class_name)
      ver_path = File.expand_path File.join(dir_path, version)
      @results_path = File.expand_path File.join(ver_path, "result")

      _pid = Process.fork do 
        Dir.chdir apk_dir
        @apk = APK.new find_apk

        Dir.mkdir 'results', 0744 unless Dir.exist? 'results'
        Dir.mkdir dir_path, 0740 unless Dir.exist? dir_path
        Dir.mkdir ver_path, 0740 unless Dir.exist? ver_path

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
           'attempted to call ResultFetcher execute'
    end

    def version
      fail NotImplementedError,
           'ResultFetcher is missing version'
    end

    def to_s
      raise "No results for '#{self.class.name.split('::').last}" \
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
