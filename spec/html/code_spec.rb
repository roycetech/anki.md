require './lib/html/code'
require './lib/highlighter/base_highlighter'

describe Code do
  let(:highlighter) { BaseHighlighter.lang_java }
  subject { Code.new(highlighter) }

  describe '#mark_codes' do
    context 'no codes' do
      let(:input) { 'one' }
      it 'does not change the input' do
        expect({ subject.mark_codes(input) }).not_to change { input }
      end
    end

    context 'with inline' do
      let(:input) { 'one `string` two' }
      it 'replaces the backticks with html tags' do
        expect { subject.mark_codes(input) }
          .to change { input }
          .from('one `string` two')
          .to('one <code class="inline">string</code> two')
      end
      it 'calls highlighter on the code inside' do
        expect(highlighter).to receive(:mark_known_codes).with('string')
        subject.mark_codes(input)
      end
    end

    context 'with well' do
      let(:input) { ['```', 'string', '```'].join("\n") }

      it 'replaces the triple backticks with html tags' do
        expect { subject.mark_codes(input) }
          .to change { input }
          .from(
            [
              '```',
              'string',
              '```'
            ].join("\n")
          )
          .to(
            [
              '<code class="well">',
              'string',
              '</code>'
            ].join("\n")
          )
      end

      it 'calls highlighter on the code inside' do
        expect(highlighter).to receive(:mark_known_codes).with('string')
        subject.mark_codes(input)
      end
    end

    context 'with well, 2 lines of code' do
      let(:input) { ['```', 'car', 'laptop', '```'].join("\n") }

      it 'replaces new lines with <br>\n' do
        expect { subject.mark_codes(input) }
          .to change { input }
          .from(
            [
              '```',
              'car',
              'laptop',
              '```'
            ].join("\n")
          )
          .to(
            [
              '<code class="well">',
              'car<br>',
              'laptop',
              '</code>'
            ].join("\n").chomp
          )
      end
    end
  end  # method
end  # class
