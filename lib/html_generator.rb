require './lib/dsl/html_dsl'
require './lib/dsl/style_dsl'
require './lib/utils/html_utils'
require './lib/html/code'
# Review requires below.

require './lib/html_builder'
require './lib/highlighter/base_highlighter'

require './lib/html/inline'

require './lib/html/style_generator'
require './lib/html/colorizer_template'

require './lib/code_detector'
require './lib/cmd_detector'

# rtfc
class HtmlGenerator
  include Markdown
  include HtmlUtils
  attr_reader :front_html, :back_html, :highlighter

  def initialize(highlighter)
    assert highlighter.is_a?(BaseHighlighter)
    @highlighter = highlighter
  end

  def format_front(tag_helper, front_array)
    card_block = front_array.join("\n")

    untagged = tag_helper.untagged? || tag_helper.back_only?
    tags_html = build_tags(tag_helper) # VERIFY IF NESTED works

    Code.new(@highlighter).mark_codes(card_block)
    output = html :div, :main do
      merge(tags_html) unless untagged
      text card_block
    end

    build_style(tag_helper, card_block, mark(output), :style_front)
  end

  def build_style(tag_helper, card_block, output, face)
    style = StyleGenerator.new(
      tag_helper,
      @highlighter.type
    ).send(face, card_block)

    "#{style}\n#{output}"
  end

  def format_back(tag_helper, back_array)
    # require 'pry';require 'pry-nav';binding.pry
    card_block = back_array.join("\n")

    output = if tag_helper.enum?
               build_enum(tag_helper, card_block)
             elsif tag_helper.figure?
               build_figure(back_array)
             else
               build_back_else(tag_helper, card_block)
             end

    build_style(tag_helper, card_block, mark(output), :style_back)
  end

  def build_main
    Code.new(@highlighter).mark_codes(card_block)
    untagged = tag_helper.untagged? || tag_helper.front_only?
    html :div, :main do
      merge(tag_htmls) unless untagged
      text card_block
    end
  end

  def build_tags(tag_helper)
    html :div, :tags do
      tag_helper.visible_tags.each do |tag|
        span :tag, tag
      end
    end
  end

  private # --------------------------------------------------------------------

  def build_figure(back_array)
    html :div, :main do
      pre :fig do
        text back_array.inject('') do |result, element|
          result + "\n" unless result.empty?
          result + element
        end
      end
    end
  end

  def build_enum(tag_helper, card_block)
    Code.new(@highlighter).mark_codes(card_block)

    return build_ol(card_block) if tag_helper.ol?

    build_ul(card_block) if tag_helper.ul?
  end

  def build_ol(card_block)
    html :div, :main do
      ol do
        card_block.each_line do |line|
          li line
        end
      end
    end
  end

  def build_ul(card_block)
    html :div, :main do
      ul do
        card_block.each_line do |line|
          li line
        end
      end
    end
  end

  def build_back_else(tag_helper, card_block)
    Code.new(@highlighter).mark_codes(card_block)
    untagged = tag_helper.untagged? || tag_helper.front_only?
    tags_html = build_tags(tag_helper) # VERIFY IF NESTED works
    html :div, :main do
      merge(tags_html) unless untagged
      merge(card_block)
    end
  end
end
