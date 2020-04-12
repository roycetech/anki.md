require './lib/utils/oper_utils'
require './lib/modules/enum_module'
require './lib/modules/quiz_module'

# unit tested
class TagHelper
  include OperUtils
  include EnumModule
  include QuizModule

  HIDDEN = %i[FB BF].freeze
  FRONT_ONLY = %i[FB Enum Practical Bool Abbr Syntax EnumU EnumO Terminology]
               .freeze

  attr_reader :front_only, :back_only, :tags

  # tags - list of Symbols
  def initialize(tags: nil, tag_line: nil)
    assert xor(tags, tag_line),
           message: 'Must set either :tags or :tag_line but not both'

    @tags = TagHelper.parse(tag_line) if tag_line
    if tags
      @tags = tags.clone if tags
      @tags.each do |item|
        assert item.class == Symbol,
               message: 'Should be array of symbols, not strings'
      end
    end

    @enum = @tags.select { |tag| %i[EnumO EnumU].include? tag }.first

    @front_only = @tags.select { |tag| FRONT_ONLY.include? tag }.any?
    @back_only = @tags.include? :BF
  end

  # parses a comma separated tags into array of tag symbols
  def self.parse(string)
    string[/@Tags: (.*)/, 1].split(',').collect do |element|
      element.strip.to_sym
    end
  end

  def index_enum(back_card)
    return unless enum? || enum_detected?(back_card)

    type = ol? ? 'O' : 'U'
    multi_tag = "Enum#{type}:#{back_card.size}".to_sym

    return if @tags.include? multi_tag

    @tags.push(multi_tag)
    @tags.delete(@enum)
  end

  def add(tag)
    @tags.push tag unless @tags.include? tag
  end

  def add_multi(tag)
    add(tag) unless enum?
  end

  def include?(tag)
    @tags.include? tag
  end

  def one_sided?
    @front_only || @back_only
  end

  def front_only?
    @front_only
  end

  def back_only?
    @back_only
  end

  def visible_tags
    @tags.reject { |tag| HIDDEN.include? tag }
  end

  def figure?
    @tags.include?(:'Figure ☖')
  end

  def untagged?
    @tags.empty?
  end
end
