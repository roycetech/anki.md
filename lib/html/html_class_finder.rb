require 'set'

#
module HtmlClassFinder
  # Looks for the format: span class="cls1 cls2"
  def find(string, element)
    list = []
    string.scan(/#{element} class="([\w\s]+)"/).collect do |item|
      if item[0] =~ /\s/
        list += item[0].split(' ')
      else
        list << item[0]
      end
    end
    Set.new(list).to_a
  end
end
