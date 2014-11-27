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
            puts self.method("meta_#{meta}").call e, data
          rescue NameError
            @log.warn "cannot dump meta/#{meta}"
          end
          
        end
      end
    end

    def skb_says app, has, fact, who:'Skb'
      %Q|#{who} says "#{app}" #{has}("#{fact}");\n|
    end

    private

    def meta_Name(entity, data)
      skb_says(entity.app.id, 'Name', data.strip)
    end

    def meta_Permissions(entity, data)
      output = ''
      data.each_line do |line|
        if line.start_with? 'uses-permission:'
          perm = line.split(':')[1].strip
          output << skb_says(entity.app.id, 'Permission', perm)
        end
      end
      return output
    end

    def meta_PlayStoreReviewScore(entity, data)
      skb_says(entity.app.id, 'ReviewScore', data.strip, who:'PlayStore')
    end

    def meta_PlayStoreCategory(entity, data)
      skb_says(entity.app.id, 'Category', data.strip, who:'PlayStore')
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

          out << skb_says(entity.app.id, "Certificate_#{key}", value)
        end
      end
      return out
    end
  end
end
