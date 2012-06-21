require 'rubygems'
require 'json'
require 'htmlentities'

module PhotoCMS

  class Photo
    attr_reader :id
    ATTS = ['username', 'nsid', 'date_taken', 'date_created', 'time_posted', 'title', 
      'views', 'tags', 'url_o', 'camera', 'iso', 'f_number', 'exposure_value', 'rating',
       'focal_length', 'lens_name', 'flash_used', 'focal_x_res', 'focal_y_res', 
       'focal_res_unit', 'exposure_mode', 'exposure_program', 'white_balance', 'shutter_speed', 'site_src',
        'id', 'flickr_src']
    
        EXIF_DISPLAY_ATTS = %w(exposure_value shutter_speed f_number iso focal_length flash_used )

        META_DISPLAY_ATTS = %w(flickr_src date_taken camera lens_name title views)

        DISPLAY_ATTS = EXIF_DISPLAY_ATTS | META_DISPLAY_ATTS
    
    
    ATTS.each do |a|
      define_method(a.to_sym) do
       @atts[a] 
      end
    end
    
    def Photo.make_slug(photo_id, title)
      title = HTMLEntities.new.encode(title)
      title_trunc = title.downcase.gsub(/\W+/, '-').split('-')[0..5].join('-')
      "#{title_trunc}-_-#{photo_id}.jpg"
    end
    
    
    def initialize(id, js)
      @id = id
      @atts = js
    end
   
   
    def display_atts
      DISPLAY_ATTS.inject({}){|h, v| h[v] = HTMLEntities.new.encode(send(v)); h}
    end
   
    def meta_exif_atts
      EXIF_DISPLAY_ATTS.inject({}){|h, v| h[v] = HTMLEntities.new.encode(send(v)); h}
    end
   
    
    


    ### some attributes
    def camera_info
      unless !camera && !lens_name
        [camera, lens_name].join(" / ")
      else
        "Unknown model"
      end
    end
    
    def on_flickr?
      !(flickr_src.blank?)
    end
    
    def slug
      Photo.make_slug(@id, title)
    end
    
    
    
  end

end

