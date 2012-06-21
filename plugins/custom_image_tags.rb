module Jekyll
  class RenderImageSizePath < Liquid::Tag
    
    def initialize(tag_name, size, tokens)
      super
      @size = size.strip
    end
    
    def render(context)
      "#{File.join(context.registers[:site].config['images_dir'], @size)}/"
    end
  end
  
  class RenderPostsPath < Liquid::Tag
     def initialize(tag_name, slug, tokens)
        super
        @slug = slug.strip
      end

      def render(context)        "#{File.join(context.registers[:site].config['posts_dir'], @slug)}"
      end
  end
end

Liquid::Template.register_tag('imgsizepath', Jekyll::RenderImageSizePath)

Liquid::Template.register_tag('postpath', Jekyll::RenderPostsPath)


