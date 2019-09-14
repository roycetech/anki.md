class SpecMaker
  def initialize(file_info)
    @classes_modules_and_methods = file_info[:classes_modules_and_methods]
    @file_name = file_info[:file_name]
  end

  def write
    puts(file_name)
    File.open("#{file_name.sub(/lib/, 'spec')}_spec.rb", 'w') do |f|
      f.write("require '#{file_name}'\n\n")
      classes_modules_and_methods.each { |line| writer(f, line) }
      f.write('end')
    end
  end

  private

  def writer(f, line)
    if line.match?(/^\s*def initialize/)
    elsif line.match?(/^\s*def/)
      f.write(method_handler(line))
    else
      f.write(module_and_class_handler(line))
    end
  end

  attr_reader :classes_modules_and_methods, :file_name

  def module_and_class_handler(line)
    string = line.gsub(/^(\S* )(\S*)(\s*)/, 'describe \2 do')
    if line == classes_modules_and_methods[0]
      string + "\n\n"
    else
      "end\n\n" + string + "\n\n"
    end
  end

  def method_handler(line)
    string = line.gsub(/^(\s*def )(.*)(\s*)/, '  describe \'#\2\' do')
    string.gsub!(/\(.*\)/, '')
    string + "\n\n  end\n\n"
  end
end

class SimpleRubyParser
  def initialize(filename, private_methods = false)
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

  def calc_name
    file.gsub(/(.*)\.(rb)/, '\1')
  end

  def to_hash
    { file_name: calc_name, classes_modules_and_methods: found_lines }
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
    return unless line.match?(/^class/)

    self.private_found = false
    found_lines << line
  end

  def grab_modules(line)
    return unless line.match?(/^module/)

    self.private_found = false
    found_lines << line
  end

  def grab_methods(line)
    found_lines << line if line.match?(/^\s*def/)
  end

  def private_finder(line)
    self.private_found = true if line.match?(/^\s*private\s*$/)
  end

  def public_finder(line)
    self.private_found = false if line.match?(/^\s*public\s*$/)
  end

  def private_found?
    @private_found
  end
end

puts(ARGV[0])
parser = if ARGV[0] == '-p'
           SimpleRubyParser.new(ARGV[1], true)
         else
           SimpleRubyParser.new(ARGV[0])
         end
parser.parse
spec = SpecMaker.new(parser.to_hash)
spec.write
puts "#{parser.get_name} has been Spec'd!"
