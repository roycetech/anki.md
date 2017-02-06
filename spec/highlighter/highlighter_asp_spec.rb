require './lib/highlighter/highlighter_asp'
require './spec/support/shared_examples_html_highlighter'

describe AspHighlighter do
  describe '#highlight_all' do
    context 'given commandline' do      
      it 'span.cmdline the whole line' do
        expect(subject.mark_known_codes('$ dotnet'))
          .to eq('<span class="cmdline">$ <span class="cmd">dotnet</span>'\
                 '</span>')
      end

      it 'span.cmd the first word' do
        expect(subject.mark_known_codes('$ dotnet run'))
          .to eq('<span class="cmdline">$ <span class="cmd">dotnet</span>'\
                 ' run</span>')
      end

      it 'span.opt the options like -t' do
        expect(subject.mark_known_codes('$ dotnet new -t web'))
          .to eq('<span class="cmdline">$ <span class="cmd">dotnet</span>'\
                 ' new <span class="opt">-t</span> web</span>')
      end
    end  # command line context

    context 'given cshtml' do
      it_behaves_like('html highlighter', AspHighlighter.new)

      it 'highlights html tag, attribute name, quotes, and symbols' do
        expect(subject.mark_known_codes('<form asp-action="Create">'))
          .to eq('<span class="symbol">&lt;</span><span class="html">form'\
                 '</span>&nbsp;<span class="attr">asp-action</span>'\
                 '<span class="symbol">=</span><span class="quote">"Create"'\
                 '</span><span class="symbol">&gt;</span>')
      end

      it 'highlights csharp codes' do
        expect(subject.mark_known_codes('@foreach(var item in Model) {'))
          .to eq('@<span class="keyword">foreach</span>(<span class="keyword">'\
                 'var</span> item <span class="keyword">in</span> Model) {')
      end

      it 'highlights asp code with csharp model codes' do
        expect(subject.mark_known_codes('<li>@item.Name</li>'))
          .to eq('<span class="symbol">&lt;</span><span class="html">li</span>'\
                 '<span class="symbol">&gt;</span>@item.Name<span '\
                 'class="symbol">&lt;/</span><span class="html">li</span>'\
                 '<span class="symbol">&gt;</span>')
      end

      it 'highlights asp model declaration' do
        expect(subject.mark_known_codes('@model List<FA.Models.Quest>'))
          .to eq('@<span class="html">model</span> List&lt;FA.Models.Quest&gt;')
      end
    end  # context: given cshtml
  end # method
end # class
