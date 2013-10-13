class GalleryList
  def self.available_directories
    dir = Dir.new $UPLOAD_ROOT

    avail = []
    dir.each do |entry|
      path = File.join($UPLOAD_ROOT, entry)
      next unless Dir.exist?(path)
      next unless finished_uploading?(path)
      avail << File.basename(path)
    end

    avail.sort
  end

  def self.finished_uploading?(path)
    last_mtime = File::Stat.new(path).mtime
    Dir.new(path).each do |subentry|
      subpath = File.join(path, subentry)
      this_mtime = File::Stat.new(subpath).mtime
      last_mtime = this_mtime if this_mtime > last_mtime
    end
    last_mtime < 30.seconds.ago
  end
end
