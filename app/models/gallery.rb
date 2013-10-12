class Gallery < ActiveRecord::Base
  has_many :images

  validates :secret,
    :format => { :with => /\A[a-zA-Z0-9]+\z/, :message => "only allows letters and numbers"},
    :length => { :in => (6..100) },
    :uniqueness => true,
    :presence => true

  def self.random_secret
    (0...12).map{ (65 + rand(26)).chr }.join
  end

  def queue_resize
    Resque.enqueue GalleryResizeJob, self.id
  end

  def work_path; File.expand_path(File.join $WORKING_PATH, self.id.to_s); end
  def upload_path; File.expand_path(File.join $UPLOAD_ROOT, self.from_directory); end
  def dir; File.expand_path(File.join $GALLERY_ROOT, self.secret); end
  def thumbdir; File.join(self.dir, 'thumb'); end
  def webdir; File.join(self.dir, 'web'); end
end
