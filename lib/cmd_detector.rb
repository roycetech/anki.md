#
class CmdDetector
  def self.cmd?(array)
    array.each { |item| return true if item =~ /^\$.*/ }
    false
  end
end
