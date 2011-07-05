class Video < Document
  after_save :videoprocess
  
  has_attached_file :file, 
                    :url => '/:class/:id.:extension',
                    :path => ':rails_root/documents/:class/:id_partition/:style.:extension',
                    :styles => {:webm => {:format => 'webm'},
                                :thumb   => {:geometry => "48x48#", :format => 'png', :time => 5}
                    },:processors => [:ffmpeg]
                    
  def videoprocess
    Resque.enqueue(Videoencoder, self.id)
  end
                      
end