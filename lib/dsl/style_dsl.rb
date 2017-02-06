# Terminology:
#   style - refers to the select block (selector and styles inside)

require './lib/dsl/selector_dsl'
require './lib/theme_store'

# DSL for the Styles
class StyleDSL
  alias global_select select

  attr_accessor :styles

  def initialize(theme, &block)
    @theme = theme
    @styles = []
    instance_eval(&block)
  end

  def select(selector, name = nil, value = nil, &block)
    @styles << global_select(selector, name, value, &block)
  end

  # :nocov:
  def to_s
    str = "<style>\n"
    @styles.each { |item| str += "#{item.apply_theme(@theme)}\n" }
    str += '</style>'
  end
  # :nocov:
end # class

# DSL Entry
def style(theme = ThemeStore::Default, &block)
  StyleDSL.new(theme, &block)
end

# # Example
# puts(style do
#   select 'div.main' do
#     text_align 'left'
#     font_size '16pt'
#   end
#   select 'input' do
#     width '100%'
#   end
# end)
