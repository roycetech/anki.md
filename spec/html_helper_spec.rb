require './lib/html_generator'
require './lib/tag_helper'
require './lib/highlighter/highlighter_java'
require './lib/highlighter/highlighter_none'

describe HtmlGenerator do
  describe '#initialize' do
    describe 'correct argument' do
      subject { HtmlGenerator.new(JavaHighlighter.new) }

      it 'accepts param of type BaseHighlighter' do
        expect(subject.highlighter).not_to be nil
      end
    end

    describe 'incorrect argument' do
      it 'raises an error' do
        expect { HtmlGenerator.new(nil) }.to raise_error(AssertionError)
      end
    end
  end # initialize()

  describe '#build_tags' do
    subject { HtmlGenerator.new(NoneHighlighter.new) }
    context 'given :Concept, :List' do
      let(:tag_helper) { TagHelper.new(tags: [:Concept, :List]) }
      it 'returns in html' do
        expect(subject.build_tags(tag_helper)).to eq([
          '<div class="tags">',
          '  <span class="tag">Concept</span>',
          '  <span class="tag">List</span>',
          '</div>'
        ].join("\n").strip)
      end
    end
  end # build_tags()

  describe '#format_front' do
    subject { HtmlGenerator.new(NoneHighlighter.new) }
    context 'given single line' do
      let(:tag_helper) { TagHelper.new(tags: []) }
      it 'returns in html' do
        expect(subject.format_front(tag_helper, ['front'])).to eq([
          '<style>',
          '  div.main {',
          '    font-size: 16pt;',
          '    text-align: left;',
          '  }',
          '</style>',
          '<div class="main">',
          '  front',
          '</div>'
        ].join("\n").strip)
      end
    end
  end # build_tags()
end # class
