VisualStudioDarkTheme
EclipseJavaClassicTheme
SublimeText2SunburstTheme
SQLDeveloperTheme
EclipseJavaClassicTheme


Theme will have list of styles they care about, for example java:
- span.keyword


Theme will contain default value for selectors.


Theme will be passed to a Style DSL, which in effect every succeeding registration will be altered based on the theme.


style VisualStudioDarkTheme do


end




theme do
  select 'code.well' do
    background_color 'black'

    select 'span' do
      select '.keyword', color: 'red'
      select '.quote' do
        color 'blue'
      end
    end
  end
end

theme do
  select 'code.well' do
    background_color 'black'

    span do
      select '.keyword', color: 'red'
      select '.quote' do
        color 'blue'
      end
    end
  end
end

# Expected Result:
{ 
  'code.well=background_color' =>  'red',
  'span.keyword=font-family' => 'monaco'
}


