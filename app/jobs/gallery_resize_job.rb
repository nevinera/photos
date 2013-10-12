require 'fileutils'

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
    prepare_destination

    File.open(File.join(gallery.dir, 'resize.log'), 'w') do |log|
      log.puts "Import in progress"
      document_input_files(log)
      resize_all_images(log)
      delete_original_directory(log)
      log.puts "Import complete - awaiting confirmation"
    end

    gallery.update_column(:state, 'resizing')
  end

  # Make a directory in GALLERY_ROOT/gallery_secret containing two subdirs:
  # one called 'thumbs', and one called 'web'
  def prepare_destination
    FileUtils.mkdir gallery.dir
    FileUtils.mkdir gallery.thumbdir
    FileUtils.mkdir gallery.webdir
  end

  def delete_original_directory(log)
    log.puts "--> Removing the originally uploaded images"
    FileUtils.rmtree gallery.work_path
  end

  # Into the destination directory:
  #   Capture the output of ls -la on working directory into a manifest.txt file
  #   Capture the md5 for each of the input files as well,
  #   and the output of the 'file' command
  def document_input_files(log)
    log.puts "--> Documenting the input files (md5, size, type) into input.txt"
    docpath = File.join(gallery.dir, 'input.txt')
    File.open(docpath, 'w') do |f|
      each_image do |path|
        f.puts "Image '#{path}':"

        ls_out = `ls -lah '#{path}'`
        f.puts "    ls: #{ls_out}"

        md5_out = `md5sum '#{path}'`.split(' ').first
        f.puts "    MD5: #{md5_out}"

        file_out = `file '#{path}'`
        f.puts "    file: #{file_out}"
      end
    end
  end

  # For each image, resize the image down to fit inside the thumbnail square,
  #   and to fit inside the web square, and put the corresponding image
  #   in the correct place. Then store the image with data into the database,
  #   attached to the gallery
  def resize_all_images(log)
    log.puts "--> Resizing images"
    offset = 0
    each_image do |image_path|
      file_name = File.basename image_path
      suffix = file_name.split('.').last.downcase
      unless suffix.present? and Image::VALID_SUFFIXES.include?(suffix)
        log.puts "    - skipping '#{file_name}' - unrecognized or missing suffix"
        next
      end

      log.puts "    - processing '#{file_name}'"

      img = Image.new
      img.original_name = file_name
      img.original_size = File.size(image_path)
      img.gallery_id = gallery.id
      img.position = offset
      img.gallery_secret = gallery.secret
      img.suffix = suffix
      img.save!

      # TODO: resize instead of copying
      log.puts "         Building Thumbnail"
      FileUtils.cp image_path, img.thumbpath

      log.puts "         Building Websize"
      FileUtils.cp image_path, img.webpath

      offset += 1
    end
  end

  def each_image(&block)
    Dir.glob(File.join gallery.work_path, '*').each do |file|
      yield File.expand_path(file)
    end
  end
end
