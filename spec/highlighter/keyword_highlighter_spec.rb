require './lib/highlighter/keyword_highlighter'
require './lib/source_parser'
require 'stringio'

describe KeywordHighlighter do
  describe '#register_to' do
    subject { KeywordHighlighter.new('nil.txt') }
    let(:parser) { SourceParser.new }

    it 'it matches full word' do
      allow(File).to receive(:read) { StringIO.new('import') }

      subject.register_to(parser)
      expect(parser.parse('import')).to \
        eq('<span class="keyword">import</span>')
    end

    it 'ignores partial match' do
      allow(File).to receive(:read) { StringIO.new('in') }
      subject.register_to(parser)
      expect(parser.parse('inside')).to eq('inside')
    end
  end

  describe 'Constructor argument must be truthy' do
    subject { KeywordHighlighter.new(nil) }
    it 'errors if falsey' do
      expect { subject }.to raise_error(RuntimeError)
    end
  end

  describe 'Keywords file must have content' do
    subject { KeywordHighlighter.new('dummy.txt') }
    it 'errors if falsey' do
      allow(File).to receive(:read) {
        StringIO.new([''].join("\n"))
      }
      expect { subject }.to raise_error(RuntimeError)
    end
  end
end # class
