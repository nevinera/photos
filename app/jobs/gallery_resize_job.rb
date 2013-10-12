class GalleryResizeJob
  attr_accessor :gallery

  def self.perform(gallery_id)
    self.new(gallery_id).work
  end

  def initialize(gallery_id)
    self.gallery = Gallery.find(gallery_id)
  end

  def work
    # Change state to 'resizing'
    # Move the directory into the working area, to WORKING_PATH/gallery_id/
    # Make a directory in GALLERY_ROOT/gallery_secret containing two subdirs:
    #   one called 'thumbs', and one called 'web'
    # Capture the output of ls -la on working directory into a manifest.txt file
    #   in the destination directory
    # For each image, resize the image down to fit inside the thumbnail square,
    #   and to fit inside the web square, and put the corresponding image
    #   in the correct place. Then store the image with data into the database,
    #   attached to the gallery
    # Keep a live log of progress (which image is being converted, stamps, etc)
    #   to be visible to admins looking at an in progress resize job.
    # Delete the original image directory
    # Change gallery state to 'awaiting-confirmation'
  end
end
