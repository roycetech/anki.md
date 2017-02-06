describe BaseHighlighter do
  describe '#initialize' do
    subject(:base_none) { BaseHighlighter.lang_none }

    # describe 'bolds text' do
    #   example 'wrapped in **text**' do
    #     expect(base_none.mark_known_codes('**text**')).to eq('<b>text</b>')
    #   end
    #   example 'wrapped in __text__' do
    #     expect(base_none.mark_known_codes('__text__')).to eq('<b>text</b>')
    #   end
    # end

    # describe 'italizes text' do
    #   example 'wrapped in *text*' do
    #     expect(base_none.mark_known_codes('*text*')).to eq('<i>text</i>')
    #   end
    #   example 'wrapped in _text_' do
    #     expect(base_none.mark_known_codes('_text_')).to eq('<i>text</i>')
    #   end
    # end
  end
end
