class Image < ActiveRecord::Base
  belongs_to :gallery

  VALID_SUFFIXES = %w{ png jpg jpeg gif }

  def filename
    "#{self.id}.#{self.suffix}"
  end

  def thumbpath
    File.expand_path(File.join $GALLERY_ROOT, self.gallery_secret, 'thumb', self.filename)
  end
  def webpath
    File.expand_path(File.join $GALLERY_ROOT, self.gallery_secret, 'web', self.filename)
  end
end
