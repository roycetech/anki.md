# require './lib/highlighter/highlighter_java'
require './lib/highlighter/base_highlighter'

describe JavaHighlighter do
  describe '#highlight_all' do
    context 'given "public @interface Ann"' do
      it 'marks the @annotation keyword' do
        expect(subject.mark_known_codes('public @interface Ann'))
          .to eq('<span class="keyword">public</span>&nbsp;<span '\
                 'class="keyword">@interface</span> Ann')
      end
    end

    input_string3 = 'int i = 0;'
    context "given '#{input_string3}'" do
      expected = '<span class="keyword">int</span> i = <span class="num">0'\
        '</span>;'
      it "returns '#{expected}'" do
        expect(subject.mark_known_codes(input_string3.clone)).to eq(expected)
      end
    end
  end
end
