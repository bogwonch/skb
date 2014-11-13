module Skb
  ##
  # Generic class for implementing app checking utilities
  #
  # These should be named in the following manner:
  #
  # FetcherName_VersionNumber_ConfigName
  class ResultFetcher < Fetcher
    def initialize(apk_dir, options=nil)
      check_name
      super apk_dir, options
    end

    ##
    # results/Tool/Version/Config/result
    def results_path
      r_path = File.expand_path File.join(@apk_dir, 'results')
      dir_path = File.expand_path File.join(r_path, tool)
      ver_path = File.expand_path File.join(dir_path, version)
      conf_path = File.expand_path File.join(ver_path, config)
      
      Dir.mkdir r_path, 0744 unless Dir.exist? r_path
      Dir.mkdir dir_path, 0740 unless Dir.exist? dir_path
      Dir.mkdir ver_path, 0740 unless Dir.exist? ver_path
      Dir.mkdir conf_path, 0740 unless Dir.exist? conf_path

      File.expand_path File.join(conf_path, "result")
    end

    private

    ##
    # Name of tool being run
    def tool
      name.split('_')[0]
    end
    
    ##
    # Version of tool being run
    def version
      name.split('_')[1]
    end

    ##
    # Configuration name of tool, else default
    def config
      return name.split('_')[2] || 'default'
    end

    ##
    # Check the class has been named according to convention
    def check_name
      parts = name.split '_'
      fail NotImplementedError, \
        "Result fetcher naming convention not being followed" \
        unless parts.length == 2 or parts.length == 3
    end

  end
end
