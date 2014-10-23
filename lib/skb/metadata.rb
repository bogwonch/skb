module Skb
  ##
  # Generic class for implementing metadata fetching utilities
  class MetadataFetcher
    attr_reader :apk

    def initialize(apk_dir)
      _pid = Process.fork do
        Dir.chdir apk_dir
        @apk = find_apk

        Dir.mkdir 'meta', 0744 unless Dir.exist? 'meta'
        class_name = self.class.name.split('::').last

        # Should we fail if we already have the metadata?
        @out = File.open(File.join('meta', class_name), 'a+')

        # Run the Fetcher
        # TODO: Drop privileges
        execute

        @out.close
      end

      Process.wait
    end

    def execute
      fail NotImplementedError,
           'attempted to call MetadataFetcher execute'
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
