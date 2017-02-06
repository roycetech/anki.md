require './spec/spec_helper'

describe JQueryHighlighter do
  describe '#highlight_all' do
    context 'when :has()' do
      it 'returns "<span class="pseudo">:has()</span>' do
        input_string = ':has()'
        expected = '<span class="pseudo">:has()</span>'
        sut = JQueryHighlighter.new
        expect(sut.highlight_all(input_string)).to eq(expected)
      end
    end
  end
end
