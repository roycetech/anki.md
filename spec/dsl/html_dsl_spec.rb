require './lib/dsl/html_dsl'

describe HTMLDSL do
  let(:answer_only) { html :span, :answer, 'Answer Only' }

  context 'empty' do
    subject do
      html :div do
      end
    end

    it 'return "<div></div>"' do
      expect(subject).to eq('<div></div>')
    end
  end

  context 'one-liner' do
    it 'is supported' do
      expect(answer_only).to eq('<span class="answer">Answer Only</span>')
    end
  end

  context 'empty with class' do
    subject do
      html :div, :main do
      end
    end
    it 'return "<div class=\"main\"></div>"' do
      expect(subject).to eq('<div class="main"></div>')
    end
  end

  context 'with self closing child' do
    subject do
      html :div, :main do
        br
      end
    end
    it 'is supported' do
      expect(subject).to eq(
        ['<div class="main">', '  <br>', '</div>'].join("\n")
      )
    end
  end

  context 'with nested block' do
    subject do
      html :div do
        code :well do
          text 'pass'
        end
      end
    end
    it 'is supported' do
      expect(subject).to eq(
        [
          '<div>',
          '  <code class="well">',
          '    pass',
          '  </code>',
          '</div>'
        ].join("\n")
      )
    end
  end

  context 'with nested block and self-closing tag' do
    subject do
      html :div do
        code :well do
          text 'pass'
        end
        hr
      end
    end
    it 'is supported' do
      expect(subject).to eq(
        [
          '<div>',
          '  <code class="well">',
          '    pass',
          '  </code>',
          '  <hr>',
          '</div>'
        ].join("\n")
      )
    end
  end

  context 'with nested one-liner' do
    subject do
      html :div do
        span :answer, 'Answer Only'
      end
    end
    it 'is supported' do
      expect(subject).to eq(
        [
          '<div>',
          '  <span class="answer">Answer Only</span>',
          '</div>'
        ].join("\n")
      )
    end
  end

  context 'Actual Use Case: with Tags' do
    subject do
      html :div, :main do
        div :tags do
          %w(Concept Topic1).each do |tag|
            span :tag, tag
          end
        end
        text 'Question 1'
      end
    end
    it 'is supported' do
      expect(subject).to eq(
        [
          '<div class="main">',
          '  <div class="tags">',
          '    <span class="tag">Concept</span>',
          '    <span class="tag">Topic1</span>',
          '  </div>',
          '  Question 1',
          '</div>'
        ].join("\n")
      )
    end
  end

  context 'Actual Use Case: List' do
    subject do
      answer_only = html :span, :answer, 'Answer Only'
      html :div, :main do
        ul do
          %w(One Two).each do |item|
            li item
          end
        end
        merge(answer_only)
      end
    end
    it 'is supported' do
      expect(subject).to eq(
        [
          '<div class="main">',
          '  <ul>',
          '    <li>One</li>',
          '    <li>Two</li>',
          '  </ul>',
          '  <span class="answer">Answer Only</span>',
          '</div>'
        ].join("\n")
      )
    end
  end

  describe  '#merge' do
    subject do
      # Must be outside DSL otherwise it will be called as DSL method.
      one_liner = answer_only
      html(:div) do
        code :well do
          text 'pass'
        end
        br
        merge(one_liner)
      end
    end

    it 'is supported' do
      expect(subject).to eq(
        [
          '<div>',
          '  <code class="well">',
          '    pass',
          '  </code>',
          '  <br>',
          '  <span class="answer">Answer Only</span>',
          '</div>'
        ].join("\n")
      )
    end

    context 'a block' do
      subject do
        block = html :div, :tags do
          span :tag, 'Concept'
        end

        html(:div) do
          merge(block)
          text 'pass'
        end
      end

      it 'is supported' do
        expect(subject).to eq(
          [
            '<div>',
            '  <div class="tags">',
            '    <span class="tag">Concept</span>',
            '  </div>',
            '  pass',
            '</div>'
          ].join("\n")
        )
      end
    end
  end # #merge
end # class
