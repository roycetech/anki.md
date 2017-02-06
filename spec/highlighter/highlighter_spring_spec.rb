require './lib/highlighter/highlighter_spring'
require './spec/support/shared_examples_html_highlighter'

describe SpringHighlighter do
  describe '#highlight_all' do
    # TODO:
    # it_behaves_like('html highlighter', SpringHighlighter.new )

    # TODO: Should be on java
    let(:with_keyword) { "char c = 'a';" }
    it 'marks keywords' do
      expect { subject.mark_known_codes(with_keyword) }\
        .to change { with_keyword }\
        .from("char c = 'a';")\
        .to(%(<span class="keyword">char</span> c = <span class="quote">'a')\
            '</span>;')
    end

    let(:xml_config) { '<sec:authentication property="name" />' }
    it 'marks xml config codes' do
      expect { subject.mark_known_codes(xml_config) }\
        .to change { xml_config }
        .from('<sec:authentication property="name" />')\
        .to('<span class="html">&lt;sec:authentication</span>&nbsp;'\
        '<span class="attr">property</span>=<span class="quote">"name"</span>'\
        '&nbsp;<span class="html">/&gt;</span>')
    end

    let(:java_annotation) { '@RolesAllowed' }
    it 'marks java annotations' do
      expect { subject.mark_known_codes(java_annotation) }\
        .to change { java_annotation }
        .from('@RolesAllowed')
        .to('<span class="ann">@RolesAllowed</span>')
    end
  end
end # end class
