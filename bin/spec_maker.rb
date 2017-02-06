class SpecMaker

  def initialize(file_info)
    @classes_modules_and_methods = file_info[:classes_modules_and_methods]
    @file_name = file_info[:file_name]

  end
  
  def write
    puts("#{ file_name }")
    File.open("#{ file_name.sub(/lib/, 'spec') }_spec.rb", 'w') do |f|
      f.write("require '#{file_name}'\n\n")
      classes_modules_and_methods.each do |line|
        if line =~ /^\s*def initialize/
        elsif line =~ /^\s*def/
          f.write(method_handler(line))
        else
          f.write(module_and_class_handler(line))
        end
      end
      f.write("end")
    end
    
  end
  
  private
  attr_reader :classes_modules_and_methods, :file_name
  
  def module_and_class_handler(line)
    string = line.gsub(/^(\S* )(\S*)(\s*)/,'describe \2 do')
    if line == classes_modules_and_methods[0]
      string + "\n\n"
    else
      "end\n\n" + string + "\n\n"
    end
  end
  
  def method_handler(line)
    string = line.gsub(/^(\s*def )(.*)(\s*)/,'  describe \'#\2\' do')
    string.gsub!(/\(.*\)/, "")
    string + "\n\n  end\n\n"
  end
end

class SimpleRubyParser

  def initialize(filename, private_methods=false)
    @file = filename
    @found_lines = []
    @private_methods = private_methods
    @private_found = false
  end
  
  def parse
    if private_methods
      grab_all
    else
      grab_public
    end
  end
  
  def get_name
    file.gsub(/(.*)\.(rb)/, '\1')
  end
  
  def to_hash
    {file_name: get_name, classes_modules_and_methods: found_lines}
  end
  
  private
  attr_reader :file, :found_lines, :private_methods
  attr_writer :private_found
  
  def grab_all
    File.foreach(file) do |line|
      grab_classes(line)
      grab_modules(line)
      grab_methods(line)
    end
  end
  
  def grab_public
    File.foreach(file) do |line|
      grab_classes(line)
      grab_modules(line)
      grab_methods(line) unless private_found?
      private_finder(line)
      public_finder(line)
    end
  end
  
  def grab_classes(line)
    if line =~ /^class/
      self.private_found=false
      found_lines << line
    end
  end
  
  def grab_modules(line)
    if line =~ /^module/
      self.private_found=false
      found_lines << line
    end
  end
  
  def grab_methods(line)
    found_lines << line if line =~ /^\s*def/
  end
  
  def private_finder(line)
    self.private_found=true if line =~ /^\s*private\s*$/
  end
  
  def public_finder(line)
    self.private_found=false if line =~ /^\s*public\s*$/
  end

  def private_found?
    @private_found
  end
end


puts(ARGV[0])
if ARGV[0] == "-p"
  parser = SimpleRubyParser.new(ARGV[1], true)
else
  parser = SimpleRubyParser.new(ARGV[0])
end
parser.parse
spec = SpecMaker.new(parser.to_hash)
spec.write
puts "#{ parser.get_name } has been Spec'd!"