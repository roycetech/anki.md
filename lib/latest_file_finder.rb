# Finds the latest modified file in a directory and its subdirectories.
class LatestFileFinder
  attr_reader :last_modified_file, :last_modified_folder,
              :last_modified_filedate

  def initialize(root_path, file_mask = '*.txt')
    @root_path              = root_path
    @file_mask              = file_mask
    @last_modified_file     = nil
    @last_modified_folder   = nil
    @last_modified_filedate = nil
  end

  def find
    recurse_find @root_path
    @last_modified_file
  end

  private

  def recurse_find(path)
    Dir[File.join(path, @file_mask)].each do |filename|
      next unless @last_modified_file.nil? ||
                  File.mtime(filename) > @last_modified_filedate

      @last_modified_file     = filename
      @last_modified_folder   = path
      @last_modified_filedate = File.mtime(filename)
    end

    dirs = list_dir(path)
    dirs.each { |dirname| recurse_find(File.join(path, dirname)) }
  end

  def list_dir(path)
    Dir.entries(path).select do |entry|
      filename = File.join(path, entry)
      File.directory?(filename) && !(entry == '.' || entry == '..')
    end
  end
end
