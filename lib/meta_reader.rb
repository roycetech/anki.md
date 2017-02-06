# Reads the meta data on top of the source file.  Will rewind after finished
# reading, for the next reader to start fresh.
class MetaReader
  def self.read(file)
    return_value = {}
    while (line = file.gets&.rstrip)
      if line =~ /^# @/
        key, value = extract(line)
        return_value[key] = value
      end
      break unless line[0, 1].empty? || line[0, 1] == '#'
    end
    file.rewind
    return_value
  end

  private_class_method

  def self.extract(line)
    key = line[/(?:@)(\w*)/, 1].downcase.to_sym
    value = line[/(?:=)(.*)/, 1]
    [key, value]
  end
end
