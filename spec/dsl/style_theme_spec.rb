require './lib/dsl/theme_dsl'

describe ThemeDSL do
  subject do
    theme do
      select 'code.well' do
        background_color 'black'
        font 'arial'
      end
      select 'span.answer', color: 'red'
    end
  end

  it 'supports single line, symbol' do
    expect(subject.get('span.answer', :color)).to eq('red')
  end

  it 'supports single line, string' do
    expect(subject.get('span.answer', 'color')).to eq('red')
  end

  it 'supports block styles' do
    expect(subject.get('code.well', :font)).to eq('arial')
  end

  it 'supports block styles, hyphenated' do
    expect(subject.get('code.well', 'background-color')).to eq('black')
  end
end # class
