class GalleryResizeJob
  attr_accessor :gallery

  def self.perform(gallery_id)
    self.new(gallery_id).work
  end

  def initialize(gallery_id)
    self.gallery = Gallery.find(gallery_id)
  end

  # TODO:
  # Keep a live log of progress (which image is being converted, stamps, etc)
  #   to be visible to admins looking at an in progress resize job.
  def work
    gallery.update_column(:state, 'resizing')

    move_to_work_zone
    prepare_destination
    document_input_files

    resize_all_images

    delete_original_directory

    gallery.update_column(:state, 'resizing')
  end

  # Move the from_directory into the working area, to WORKING_PATH/gallery_id/
  def move_to_work_zone
  end

  # Make a directory in GALLERY_ROOT/gallery_secret containing two subdirs:
  # one called 'thumbs', and one called 'web'
  def prepare_destination
  end

  def delete_original_directory
  end

  # Into the destination directory:
  #   Capture the output of ls -la on working directory into a manifest.txt file
  #   Capture the md5 for each of the input files as well,
  #   and the output of the 'file' command
  def document_input_files
  end

  # For each image, resize the image down to fit inside the thumbnail square,
  #   and to fit inside the web square, and put the corresponding image
  #   in the correct place. Then store the image with data into the database,
  #   attached to the gallery
  def resize_all_images
    each_image do |image_path|
      produce_thumbnail_image
      produce_web_image
      create_image_in_db
    end
  end

  def each_image(&block)
  end


  # use image magick somehow to perform these conversions
  def produce_thumbnail_image
  end
  def produce_web_image
  end

  # store information about the images - sizes, original names, etc
  # add an entry to the images table that belongs to the gallery being built
  def create_image_in_db
  end

end
