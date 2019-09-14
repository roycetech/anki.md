class TagCounter
  attr_reader :tags_count

  def initialize
    @tags_count = {}
  end

  # common_tag - used for ?
  def count_tags(file, _common_tag = nil)
    SourceReader.new(file).each_card do |tags, _front, _back|
      register_tags(tags)
    end

    file.rewind
    @tags_count
  end

  def register_tags(tags)
    tags.each do |tag|
      count = @tags_count[tag] || 0
      count += 1
      @tags_count[tag] = count
    end
  end
end
