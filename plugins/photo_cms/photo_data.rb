require 'rubygems'
require 'erb'
require 'json'
require 'active_support/inflector'

module Jekyll
  class RenderPhotoData < Liquid::Tag
    include TemplateWrapper     
    def initialize(tag_name, fname_arg, tokens)
      super
      @fname_arg = fname_arg.strip
    end
    
    
    def render(context)
      if @fname_arg == '__page_ledeimage'
        @fname = context.environments.first["page"]["ledeimage"]
        @size = 'large'
      else
        @fname, @size = @fname_arg.strip.split(/ +/)
      end
      
      
      if photo = get_data_object(context)
        img_path = get_image_path(context)

        if File.exists?(img_path)
          b_path = img_path.split('/')[-2..-1].join('/')
          puts img_path + "  moving to: " + File.join(PhotoCMS::ASSETS_DIR, b_path)
          # copy to working directory
    #      Photo::CMS.copy_to_source(img_path)
        end

        div = ERB.new(PhotoCMS::PHOTO_DIV_TEMPLATE)
        return safe_wrap(div.result(binding).encode('UTF-8', 'UTF-8', :invalid => :replace))        
#        "#{File.join(context.registers[:site].config['images_dir'], @size)}/"
      end  
    end
    
    private
    
    def get_image_path(context)
      File.join(context.registers[:site].config['images_dir'], @size, @fname).encode('UTF-8', 'UTF-8', :invalid => :replace)
    end
    
    
    
    def get_data_object(context)
      if d = File.basename(@fname).match(/-_-(\d+)/)
        id = d[1]
        if pd = context.registers[:site].photos[id]
          return pd
        else
          raise "Could not find id #{id}"
        end
      else
        raise "Could not find file #{@fname}"
        return nil
      end
    end
    
    
    
  end
end

Liquid::Template.register_tag('imgdatadiv', Jekyll::RenderPhotoData)




module PhotoCMS
  PHOTO_DIV_TEMPLATE = %q{
    <div class="photo-cms-file">
     <img src="<%=img_path%>" id="flickr-<%=photo.id%> alt="<%=photo.title%> title=<%=photo.title%>" <%=photo.display_atts.map{|k,v| "data-#{k}=\"#{v}\"" }.join(' ')%> />
     <div class="photo-meta">
        <ul class="exif">
         <% photo.meta_exif_atts.each_pair do |k,v| %>
           <li><span class="att"><%=k.humanize%></a></span>: <span class="val"><%=v%></span></li>
           <% end %>
         </ul>
         <div class="info">
           <% if photo.flickr_src %>
             <a href="<%=photo.flickr_src%>">View on Flickr</a>
           <% end %>
           
           Taken with <span class="val"><%=photo.camera_info%></span> on <%=Time.parse(photo.date_taken).strftime('%h %e, %Y at %I:%M %p')%>
           
         </div>
        </div>
      </div>    
  }
  

end