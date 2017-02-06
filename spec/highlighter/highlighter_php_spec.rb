require './lib/highlighter/highlighter_php'
require './spec/support/shared_examples_html_highlighter'

describe PhpHighlighter do
  describe '#highlight_all' do
    # TODO:
    # it_behaves_like('html highlighter', PhpHighlighter.new )

    let(:perl_comment) { 'Test # comment' } 
    it 'highlights perl comment' do
      expect { subject.mark_known_codes(perl_comment) }\
        .to change { perl_comment }\
        .from('Test # comment')\
        .to('Test <span class="comment"># comment</span>')
    end

    let(:global_var) { 'global $globalvar;' }
    it 'highlights keywords and global variable' do
      expect { subject.mark_known_codes(global_var) }\
        .to change { global_var }\
        .from('global $globalvar;')\
        .to('<span class="keyword">global</span>&nbsp;<span class="var">'\
            '$globalvar</span>;')
    end

    let(:destructor) { 'function __destruct() {}' }
    it 'can mark destructor function declaration' do
      expect { subject.mark_known_codes(destructor) }\
        .to change { destructor }
        .from('function __destruct() {}')
        .to('<span class="keyword">function</span> __destruct() {}')
    end

    let(:opentag) { '<?php' }
    it 'can mark open tag' do
      expect { subject.mark_known_codes(opentag) }.to \
        change { opentag }\
        .from('<?php')\
        .to('<span class="phptag">&lt;?php</span>')
    end

    let(:short_opentag) { '<?' }
    it 'can mark short open tag' do
      expect { subject.mark_known_codes(short_opentag) }\
        .to change { short_opentag }
        .from('<?')\
        .to('<span class="phptag">&lt;?</span>')
    end

    let(:closetag) { '?>' }
    it 'can mark closing tag' do
      expect { subject.mark_known_codes(closetag) }\
        .to change { closetag }\
        .from('?>')\
        .to('<span class="phptag">?&gt;</span>')
    end
  end
end
