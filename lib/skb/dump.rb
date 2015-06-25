require 'skb/command'
require 'skb'

module Skb
  ##
  # Implements the command used to dump the SKB into SecPAL
  class DumpSecPALCommand < Skb::Command
    def execute
      apps = Dir[File.join(@options.location, '*')]
      apps.each do |app|
        e = Entry.new(app)
        @log.info "dumping #{e.app.id}"

        e.meta.each do |meta|
          data = e.fetch_meta meta
          begin
            puts method("meta_#{meta}").call e, data
          rescue NameError
            @log.warn "cannot dump meta/#{meta}"
          end
        end

        e.result.each do |result|
          r, v, c = result
          data = e.fetch_result result
          begin
            puts method("result_#{r}").call e, data
          rescue NameError
            @log.warn "cannot dump result/#{r}/#{v}/#{c}"
          end
        end
      end
    end

    def skb_says(app, has, fact, who: 'skb')
      %|"#{who}" says "#{app}" #{has}("#{fact}").\n|
    end

    private

    def meta_Name(entity, data)
      skb_says(entity.app.id, 'hasName', data.strip)
    end

    def meta_Permissions(entity, data)
      output = ''
      data.each_line do |line|
        if line.start_with? 'uses-permission:'
          perm = line.split(':')[1].strip
          output << skb_says(entity.app.id, 'hasPermission', perm)
        end
      end
      output
    end

    def meta_PlayStoreReviewScore(entity, data)
      skb_says(entity.app.id, 'hasReviewScore', data.strip, who: 'PlayStore')
    end

    def meta_PlayStoreCategory(entity, data)
      skb_says(entity.app.id, 'hasCategory', data.strip, who: 'PlayStore')
    end

    # This isn't a great dumping function.
    # Should refactor to make statements about the certificate
    # ...and split fields better
    def meta_Certificate(entity, data)
      out = ''
      data.each_line do |line|
        fields = line.split(': ')
        unless fields.length != 2
          key = fields[0].strip.gsub ' ', '_'
          value = fields[1].strip.gsub '"', ''

          out << skb_says(entity.app.id, "hasCertificate#{key}", value)
        end
      end
      out
    end
  end
end
