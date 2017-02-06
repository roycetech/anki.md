require './lib/html_generator'
require './lib/highlighter/base_highlighter'

describe HtmlGenerator do
  subject { HtmlGenerator.new(BaseHighlighter.lang_ruby) }

  describe '#format_back' do
    context 'enum' do
      let(:tag_helper_enum) { TagHelper.new(tag_line: '@Tags: EnumU') }
      let(:back_list) { %w(line1 line2) }

      it 'formats a list' do
        expect(subject.format_back(tag_helper_enum, back_list))\
          .to eq(SpecUtils.join_array([
                                        '<style>',
                                        '  div.main {',
                                        '    font-size: 16pt;',
                                        '    text-align: left;',
                                        '  }',
                                        '</style>',
                                        '<div class="main">',
                                        '  <ul>',
                                        '    <li>line1</li>',
                                        '    <li>line2</li>',
                                        '  </ul>',
                                        '</div>'
                                      ]))
      end
    end
    context 'none code' do
      let(:tag_helper) { TagHelper.new(tags: []) }
      describe 'bolds text' do
        example 'wrapped in **text**' do
          expect(subject.format_back(tag_helper, ['**text**']))
            .to match(%r{<b>text<\/b>})
        end
        example 'wrapped in __text__' do
          expect(subject.format_back(tag_helper, ['__text__']))
            .to match(%r{<b>text<\/b>})
        end
      end

      describe 'italizes text' do
        example 'wrapped in *text*' do
          expect(subject.format_back(tag_helper, ['*text*']))
            .to match(%r{<i>text<\/i>})
        end
        example 'wrapped in _text_' do
          expect(subject.format_back(tag_helper, ['_text_']))
            .to match(%r{<i>text<\/i>})
        end
      end
    end
  end # format_back
end # class
