# Few choices so we use template method.
class ColorizerTemplate
  def convert(selector, style_name, style_value)
    key = "#{selector}{#{style_name}"

    converted = mapping[key]
    converted || style_value
  end

  # @Abstract
  # def get_mapping() end
end

# Theme for Dark
class DarkColorizer < ColorizerTemplate
  def initialize
    @mapping = {
      'span.quote{color' => '#66CC33',
      'span.keyword{color' => '#CC7833',
      'span.cmd{color' => '#CC7833',
      'span.opt{color' => '#AAAAAA',
      'div.well{background-color' => 'black',
      'div.well{color' => '#D4D4D4',
      'code.inline{background-color' => 'black',
      'code.inline{color' => '#D4D4D4'
    }
  end

  attr_reader :mapping
end

# Theme for VSC
class VisualStudioColorizer < ColorizerTemplate
  def initialize
    @mapping = {
      'span.quote{color' => '#CE9178',
      'span.keyword{color' => '#5294CB',
      'span.cmd{color' => '#CC7833',
      'span.opt{color' => '#AAAAAA',
      'span.comment{color' => '#608B4E',
      'div.well{background-color' => '#1E1E1E',
      'div.well{color' => '#D2D2D2',
      'span.attr{color' => '#9ADAFC'
    }
  end
  attr_reader :mapping
end

# Light theme
class LightColorizer < ColorizerTemplate
  def initialize
    @mapping = {}
  end

  attr_reader :mapping
end
