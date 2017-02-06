require './lib/highlighter/highlighter_erb'
require './spec/support/shared_examples_html_highlighter'

describe ErbHighlighter do
  describe '#highlight_all' do
    context 'given commandline' do
      it 'span.cmdline the whole line' do
        expect(subject.mark_known_codes('$ rails --version'))\
          .to eq('<span class="cmdline">$ <span class="cmd">rails</span> '\
                 '--version</span>')
      end
    end  # command line context

    context 'given erb.html' do
      it_behaves_like('html highlighter', AspHighlighter.new)
    end  # context: given erb.html
  end # method
end # class
