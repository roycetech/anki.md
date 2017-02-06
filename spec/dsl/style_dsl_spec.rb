require './lib/dsl/selector_dsl'
require './lib/dsl/style_dsl'

describe StyleDSL do
  subject(:dsl) do
    style do
      select 'div.main' do
        text_align 'left'
        font_size '16pt'
      end
      select 'input', :width, '100%'
    end
  end

  it 'returns a type of StyleDSL' do
    expect(subject).to be_kind_of(StyleDSL)
  end

  it 'maintains list of selectors' do
    expect(dsl.styles.count).to eq(2)
  end

  it 'formats style with proper indentation' do
    expect(dsl.to_s).to eq(
      [
        '<style>',
        '  div.main {',
        '    text-align: left;',
        '    font-size: 16pt;',
        '  }',
        '  input { width: 100%; }',
        '</style>'
      ].join("\n")
    )
  end

  let(:extra_selector) do
    select 'span', :color, :red
  end

  it 'can add additional selector' do
    expect { subject.styles << extra_selector }
      .to change { subject.styles.count }.by(1)
  end

  it 'includes additional selectors to output' do
    expect { subject.styles << extra_selector }
      .to change { subject.to_s }
      .from(
        [
          '<style>',
          '  div.main {',
          '    text-align: left;',
          '    font-size: 16pt;',
          '  }',
          '  input { width: 100%; }',
          '</style>'
        ].join("\n")
      )
      .to(
        [
          '<style>',
          '  div.main {',
          '    text-align: left;',
          '    font-size: 16pt;',
          '  }',
          '  input { width: 100%; }',
          '  span { color: red; }',
          '</style>'
        ].join("\n")
      )
  end
end # class
