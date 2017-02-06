require './lib/highlighter/highlighter_ruby'

describe RubyHighlighter do
  describe '#highlight_all' do
    let(:perl_comment) { 'Test # comment' }
    it 'highlights perl comment' do
      expect { subject.mark_known_codes(perl_comment) }\
        .to change { perl_comment }\
        .from('Test # comment')\
        .to('Test <span class="comment"># comment</span>')
    end

    let(:global_var) { '$var = 42' }
    it 'highlights global variables' do
      expect { subject.mark_known_codes(global_var) }\
        .to change { global_var }\
        .from('$var = 42')\
        .to('<span class="var">$var</span> = 42')
    end
    let(:block_var) { '|ab, _b|' }
    it 'highlights block variables' do
      expect { subject.mark_known_codes(block_var) }\
        .to change { block_var }\
        .from('|ab, _b|')\
        .to('|<span class="var">ab</span>, <span class="var">_b</span>|')
    end
  end
end
