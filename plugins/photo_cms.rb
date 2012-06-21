module PhotoCMS
  
#  ASSETS_DIR = "_assets_hold"
  
#  PhotoCMS.copy_to_source(path)
    
  
  
end

module Jekyll

  class Site
  # Read and parse the JSON file under the data directory
  # +filename+ is the String name of the file to be read
  
    attr_reader :photos
    def read_photo_json( filename='photos.json' )
      data_dir = self.config['data_dir']
      data_path = File.join(self.config['source'], data_dir)
      file = File.join(data_path, filename)

      return "File #{file} could not be found" if !File.exists?( file )
    
      result = nil
      Dir.chdir(data_path) do
        result = File.read( filename )
      end
      puts "## Error: No data in #{file}" if result.nil?
      # puts result
      result = JSON.parse( result ) if result
      
      @photos ||= {} #sloppy
      
      result.each_pair do |key, js|
        p = PhotoCMS::Photo.new(key, js)
        @photos[key] = p
      end
      
      
    end
    
    
    # end site extension
    
    class PhotoCmsGenerator < Generator
       safe true

       def generate(site)
         site.read_photo_json
         
       end
    end


  end
end


