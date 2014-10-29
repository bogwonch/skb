require 'ruby-filemagic'

module Skb
  ##
  # APK objects represent Android APKs
  class APK
    attr_reader :path, :id

    def initialize(path)
      @path = path
      validate
      @id = create_id
    end

    ##
    # Gets the ID used to identify +file+ in the SKB
    #
    # Currently this is the SHA1 hash.
    #
    # This function does no validation that +file+ is an actual app.
    def create_id
      Rickshaw::SHA1.hash(@path)
    end

    ##
    # Check whether two APKs are the same.
    #
    # We do this by comparing multiple hashes of the file.  If they're all the
    # same hash then we assume it's the same file.
    #
    # TODO: byte for byte checking?
    def same_as(apk)
      md5_a    = Rickshaw::MD5.hash(@path)
      md5_b    = Rickshaw::MD5.hash(apk)
      sha1_a   = Rickshaw::SHA1.hash(@path)
      sha1_b   = Rickshaw::SHA1.hash(apk)
      sha256_a = Rickshaw::SHA256.hash(@path)
      sha256_b = Rickshaw::SHA256.hash(apk)

      md5_a == md5_b && sha1_a == sha1_b && sha256_a == sha256_b
    end

    ##
    # Checks that +apk+ looks like an actual Android application
    #
    # Checks that +apk+ exists, isn't a directory and has the correct MIME
    # type.
    #
    # An ArgumentError is raised if +apk+ doesn't appear to be valid.
    def validate
      fail ArgumentError, "The file '#{@path}' does not exist" \
        unless File.exist? @path

      fail ArgumentError, "The file '#{@path}' is a directory" \
        if File.directory? @path

      mime = MIME::Types.of(@path).first.simplified
      fail ArgumentError, \
           "The file '#{@path} has the wrong MIME type: #{mime}" \
        unless mime == 'application/vnd.android.package-archive'

      # Check the Magic type:  I suspect this will be fragile
      ft = FileMagic.fm(:symlink).file(@path)
      fail ArgumentError, "The file '#{@path}' doesn't seem to be an APK (#{ft})" \
        unless ft == 'Java archive data (JAR)' or \
               ft == 'Microsoft OOXML'         or \
               ft.start_with? 'Zip archive data'

    end

    ##
    # Add +apk+ to the SKB
    def add(path, log)
      target = File.join path, @id
      if already_exists target
        log.warn "APK '#{@path}' already exists... skipping"
      else
        # TODO: Drop permissions and set correct UID
        FileUtils.mkdir target, mode: 0700
        FileUtils.cp @path, target
      end
    end

    ##
    # Check whether +apk+ already exists.
    #
    # May throw exceptions if the file is there but something is wrong or we
    # have found a hash collision.
    def already_exists(apk_dir)
      # Is the APK already present in the SKB?
      return false unless File.directory? apk_dir

      # Check if its the same apk
      apks = Dir["#{apk_dir}/*.apk"]

      fail SecurityError,
           "There is already an APK in the SKB with id '#{@id}'," \
           'but it seems odd. Please check SKB consistency.' \
        if apks.length != 1

      fail NameError,
           "The apk '#{apk}' collides with an existing" \
           "entry in the SKB with id: #{@id}" \
        unless same_as apks.first

      return true
    end
  end
end
