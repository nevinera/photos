class GalleryList
  def self.available_directories
    dir = Dir.new $UPLOAD_ROOT

    avail = []
    each_subpath($UPLOAD_ROOT) do |path|
      next unless finished_uploading?(path)
      avail << File.basename(path)
    end
    avail.sort
  end

  def self.each_subpath(path, &block)
    dir = Dir.new path
    return nil unless Dir.exist?(path)

    dir.each do |entry|
      next if entry =~ /^\./
      next unless File.exist?(path)
      subpath = File.join(path, entry)
      yield subpath
    end
  end

  def self.finished_uploading?(path)
    last_mtime = 1.day.ago
    each_subpath(path) do |subpath|
      this_mtime = File::Stat.new(subpath).mtime
      last_mtime = this_mtime if this_mtime > last_mtime
    end
    last_mtime < 10.seconds.ago
  end
end
