require './lib/highlighter/highlighter_python'

describe PythonHighlighter do
  describe '#highlight_all' do
    describe 'given multi line' do
      let(:input) do
        [
          %(multiline = '''\\),
          'Line 1',
          %(Line 2''')
        ].join("\n").chomp
      end

      let(:expected) do
        [
          %(multiline = <span class="quote">'''\\),
          'Line 1',
          %(Line 2'''</span>)
        ].join("\n").chomp
      end

      it 'wraps multiline in span' do
        expect(subject.mark_known_codes(input)).to eq(expected)
      end
    end # context

    describe 'raw string' do
      it 'it wraps given single quote' do
        expect(subject.mark_known_codes(%q(raw = r'c:\Users')))\
          .to eq(%q(raw = <span class="quote">r'c:\Users'</span>))
      end
      it 'it wraps given double quote' do
        expect(subject.mark_known_codes(%q(raw = r"c:\Users")))\
          .to eq(%q(raw = <span class="quote">r"c:\Users"</span>))
      end
    end # end context raw string
  end # method
end # class
