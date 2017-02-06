

# Do bunch of apply, then invoke end_apply to close the style tag
class StyleHelper

  def initialize(tag_helper, lang='none', iscmd=false)

    $logger.debug(lang)

    @colorizer = if lang == 'git' || iscmd
      DarkColorizer.new
    elsif ['asp', 'csharp'].include?(lang)
      VisualStudioColorizer.new
    else 
      LightColorizer.new
    end
    $logger.debug(@colorizer)

    @lang = lang
    @tag_helper = tag_helper

    @style_common = StyleBuilder.new(nil, @colorizer)
      .select('div.main')
        .text_align('left')
        .font_size('16pt')
      .select_e
      .select('code.inline')
        .border('1px solid #DDD')
        .font_family("monaco, courier")
        .font_size('13pt')
        .background_color('#F1F1F1')
        .color('black')
        .border_radius('5px')
        .padding_left('2px')
        .padding_right('2px')
      .select_e

    shown_tags = tag_helper.visible_tags
    unless tag_helper.visible_tags.empty?
      @style_common
        .select('span.tag')
          .background_color('#5BC0DE')
          .color('white')
          .border_radius('5px')
          .padding('2px')
        .select_e
    end

  end


  # Assumes that builder is an empty builder.
  def apply_common(html_builder)
    html_builder.merge(@style_common)
  end


  def apply_figure(html_builder)
    html_builder.merge(
      StyleBuilder.new(nil, @colorizer)
      .select('.fig')
        .line_height('70%')
      .select_e)
  end


  def apply_command(html_builder)
    html_builder.merge(StyleBuilder.new(nil, @colorizer)
      .select('code.command')
        .color('white')
        .background_color('black')
      .select_e)
  end


  def apply_answer_only(html_builder)
    answer_only_style = StyleBuilder.new(nil, @colorizer)
      .select('span.answer_only')
        .font_weight('bold')
        .background_color('#D9534F')
        .color('white')
        .border_radius('5px')
        .padding('2px 5px')
        .display('table')
        .margin('0 auto')
      .select_e

    html_builder.merge(answer_only_style)
  end


  def apply_code(html_builder)
     style = StyleBuilder.new(nil, @colorizer)
      .select('div.well')
        .min_height('20px')
        .padding('19px')
        .color('black')
        .font_family('monaco, courier')
        .margin_bottom('20px')
        .background_color('#F1F1F1')
        .border('1px solid #e3e3e3')
        .border_radius('4px')
        .box_shadow('inset 0 1px 1px rgba(0, 0, 0, 0.05)')
        .font_size('14pt')
      .select_e
      .select('span.keyword')
        .color('#7E0854')
      .select_e
      .select('span.cmd')
        .color('#7E0854')
      .select_e
      .select('span.comment')
        .color('#417E60')
      .select_e
      .select('span.quote')
        .color('#1324BF')
      .select_e
      .select('span.var')
        .color('#426F9C')
      .select_e
      .select('span.url')
        .color('blue')
      .select_e
      .select('span.html')
        .color('#446FBD')
      .select_e
      .select('span.attr')
        .color('#6D8600')
      .select_e
      .select('span.cls')
        .color('#6D8600')
      .select_e
      .select('span.num')
        .font_weight('bold')
        .color('#812050')
      .select_e
      .select('span.opt')
        .color('darkgray')
      .select_e
      
      style = case @lang
        when HighlightersEnum::PHP
          style.select('span.phptag')
            .color('#FC0D1B')
          .select_e
        when HighlightersEnum::JAVA
          style.select('span.ann')
            .color('#426F9C')
          .select_e
        when HighlightersEnum::ASP
          style.select('span.symbol')
            .color('#808080')
          .select_e
        when HighlightersEnum::GIT
          style.select('span.opt')
            .color('black')
          .select_e
          .select('span.cmd')
            .color('#FFFF9B')
          .select_e
      end || style

      html_builder.merge(style)
  end

end