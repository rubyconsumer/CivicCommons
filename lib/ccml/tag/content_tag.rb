module CCML
  module Tag

    class ContentTag < TagPair

      def index
        type = @opts[:type]
        type = 'untyped' if type.nil? 
        items = ContentItem.where(:content_type => type.classify)
        return process_tag_body(items)
      end

      def blogs
        @opts[:type] = 'blog_post'
        return index
      end

    end
  
  end
end
