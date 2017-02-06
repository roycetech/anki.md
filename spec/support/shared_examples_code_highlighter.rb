shared_examples_for 'html highlighter' do |highlighter|
  it 'escapes spaces to &nbsp;' do
    expect(highlighter.mark_known_codes(' <span>')).to match(/&nbsp;.*/)
  end

  it 'escapes angles' do
    expect(highlighter.mark_known_codes(' <span>')).not_to match(/<span>/)
  end

  it 'ignores <br>' do
    input = 'one<br>'
    expect { highlighter.mark_known_codes(input) }.not_to change { input }
  end
end
