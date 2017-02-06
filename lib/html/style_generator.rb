# require './lib/class_extensions'
# require './lib/mylogger'
# DEV Only requries above.

require './lib/code_detector'
require './lib/dsl/style_dsl'
require './lib/dsl/selector_dsl'
require './lib/tag_helper'
require './lib/html/html_class_finder'
require './lib/html/style_list'
require './lib/highlighter/highlighters_enum'
require './lib/theme_store'

# Do bunch of apply, then invoke end_apply to close the style tag
class StyleGenerator
  include HtmlClassFinder, HighlightersEnum, CodeDetector

  def initialize(tag_helper, lang = 'none')
    @tag_helper = tag_helper
    # $logger.info(lang)

    # # theming.
    # @colorizer = if lang == 'git' || iscmd
    #   DarkColorizer.new
    # elsif ['asp', 'csharp'].include?(lang)
    #   VisualStudioColorizer.new
    # else
    #   LightColorizer.new
    # end
    # $logger.debug(@colorizer)

    @lang = lang
  end

  def style_front(front_card_block)
    front_style = style {}
    front_style.styles << build_main

    no_tag = @tag_helper.untagged? || @tag_helper.back_only?
    front_style.styles << build_tag unless no_tag

    tags = find(front_card_block, :span)
    build_code(tags) { |style| front_style.styles << style }

    front_style.styles << build_inline if inline?(front_card_block)

    front_style
  end

  def style_back(back_card_block)
    back_style = style(get_theme) {}
    back_style.styles << build_main

    no_tag = @tag_helper.untagged? || @tag_helper.front_only?
    back_style.styles << build_tag unless no_tag
    back_style.styles << build_figure if @tag_helper.figure?
    back_style.styles << build_command if command?(back_card_block)
    back_style.styles << build_well if well?(back_card_block)
    back_style.styles << build_inline if inline?(back_card_block)

    tags = find(back_card_block, :span)

    build_code(tags) { |style| back_style.styles << style }
    back_style
  end

  def get_theme
    case @lang
    when HighlightersEnum::RUBY
      ThemeStore::SublimeText2_Sunburst_Ruby
    else
      ThemeStore::Default
    end
  end

  def build_main
    select 'div.main' do
      font_size '16pt'
      text_align 'left'
    end
  end

  def build_tag
    select 'span.tag' do
      background_color '#5BC0DE'
      border_radius '5px'
      color 'white'
      font_size '14pt'
      padding '2px'
      margin_right '10px'
    end
  end

  def build_answer_only
    select 'span.answer' do
      background_color '#D9534F'
      border_radius '5px'
      color 'white'
      display 'table'
      font_weight 'bold'
      margin '0 auto'
      padding '2px 5px'
    end
  end

  def build_figure
    select '.fig', :line_height, '70%'
  end

  def build_inline
    select 'code.inline' do
      background_color '#F1F1F1'
      border '1px solid #DDD'
      border_radius '5px'
      color 'black'
      font_family 'monaco, courier'
      font_size '13pt'
      padding_left '2px'
      padding_right '2px'
    end
  end

  def build_command
    select 'code.command' do
      color 'white'
      background_color 'black'
    end
  end

  def build_well
    select 'code.well' do
      background_color '#F1F1F1'
      border '1px solid #E3E3E3'
      border_radius '4px'
      box_shadow 'inset 0 1px 1px rgba(0, 0, 0, 0.05)'
      color 'black'
      display 'block'
      font_family 'monaco, courier'
      font_size '14pt'
      margin_bottom '20px'
      min_height '20px'
      padding '19px'
    end
  end

  def build_code(tags)
    style_list = StyleList.new(tags)
    style_list.add('keyword', :color, '#7E0854')
    style_list.add('comment', :color, '#417E60')
    style_list.add('quote', :color, '#1324BF')
    style_list.add('var', :color, '#426F9C')
    style_list.add('url', :color, 'blue')
    style_list.add('html', :color, '#446FBD')
    style_list.add('attr', :color, '#6D8600')
    style_list.add('cls', :color, '#6D8600')
    style_list.add('num', :color, '#812050')
    style_list.add('opt', :color, 'darkgray')
    # style_list.add('cmd', :color, '#7E0854')

    # Per language Styles
    style_list.add('phptag', :color, '#FC0D1B') if @lang == PHP
    style_list.add('ann', :color, '#FC0D1B') if @lang == JAVA
    style_list.add('symbol', :color, '#808080') if @lang == ASP
    if @lang == GIT
      style_list.add('opt', :color, 'black')
      style_list.add('cmd', :color, '#FFFF9B')
    end

    style_list.each { |style| yield style }
  end
end

# # tag_helper = TagHelper.new(tags: [])
# # tag_helper = TagHelper.new(tags: [:Concept])
# tag_helper = TagHelper.new(tags: [:FB])
# # tag_helper = TagHelper.new(tags: [:BF])
# generator =  StyleGenerator.new(tag_helper)
# puts( generator.style_back(['span class="keyword comment"']) )
