module Skb
  module APK
    ## 
    # Gets the ID used to identify +file+ in the SKB
    #
    # Currently this is the SHA1 hash.
    #
    # This function does no validation that +file+ is an actual app.
    def self.get_id(file)
      Rickshaw::SHA1.hash(file)
    end

    ##
    # Check whether two APKs are the same.
    #
    # We do this by comparing multiple hashes of the file.  If they're all the
    # same hash then we assume it's the same file.
    #
    # TODO: byte for byte checking?
    def self.same(apk_a, apk_b)
      md5_a    = Rickshaw::MD5.hash(apk_a)
      md5_b    = Rickshaw::MD5.hash(apk_b)
      sha1_a   = Rickshaw::SHA1.hash(apk_a)
      sha1_b   = Rickshaw::SHA1.hash(apk_b)
      sha256_a = Rickshaw::SHA256.hash(apk_a)
      sha256_b = Rickshaw::SHA256.hash(apk_b)

      md5_a == md5_b and sha1_a == sha1_b and sha256_a == sha256_b  
    end
  end
end
