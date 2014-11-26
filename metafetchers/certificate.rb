require 'skb'
require 'zip/zip'

module MetaFetcher
  ##
  # Extracts the certificate used in the APK
  class Certificate < Skb::MetaFetcher
    def execute
      Zip::ZipFile.open @apk.path do |apk|
        cert = apk.find_entry 'META-INF/CERT.RSA'
        unless cert.nil?
          Dir.mktmpdir do |dir|
            cert.extract "#{dir}/CERT.RSA"
            out = `openssl pkcs7 -in '#{dir}/CERT.RSA' -inform DERM -print_certs | openssl x509 -noout -text`
            @out << out
          end
          return true
        end
      end
      return false
    end
  end
end
