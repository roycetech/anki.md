require './lib/dsl/theme_dsl'

#
class ThemeStore
  SublimeText2_Sunburst_Ruby = theme do
    select 'code.well' do
      background_color 'black'
      color '#F8F8F8'
    end
    select 'span.comment', color: '#AEAEAE'
    select 'span.keyword', color: '#E28964'
    select 'span.quote', color: '#65B043'
  end

  Default = theme {}
end
