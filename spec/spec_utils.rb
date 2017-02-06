require './lib/utils/html_utils'

#
module SpecUtils
  include HtmlUtils

  # 1. changes &nbsp; to space to easy matching.
  # 2. removes trailing spaces.
  def self.clean_html(string)
    string.gsub(/#{ ESP }/, ' ').strip
  end

  def self.join_array(array)
    array.join("\n").strip
  end
end
