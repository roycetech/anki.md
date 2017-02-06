require './lib/highlighter/highlighter_web'

describe WebHighlighter do
  describe '#highlight_all' do
    let(:non_html) { 'hello' }
    it 'does not change non-html' do
      expect { subject.mark_known_codes(non_html) }.not_to change { non_html }
    end
  end
end # class
