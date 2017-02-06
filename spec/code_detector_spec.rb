require './lib/code_detector'

describe CodeDetector do
  subject { Object.new.extend(CodeDetector) }

  describe '#well?' do
    let(:well_placeholder) { ['```', 'one', '```'] }
    let(:well_html) { ['<code class="well">', 'one', '</code>'] }

    it 'supports code block place holder' do
      expect(subject.well?(well_placeholder.join("\n"))).to be true
    end

    it 'supports code block html' do
      expect(subject.well?(well_html.join("\n"))).to be true
    end

    it 'supports string array placeholder' do
      expect(subject.well?(well_placeholder)).to be true
    end

    it 'supports string array html' do
      expect(subject.well?(well_html)).to be true
    end
  end

  # Note: 1. Context Are Grouped into input types: no code, with inline, well,
  # and both.
  context 'no code' do
    let(:input) { ['one'] }

    describe '.code?' do
      it('returns false') { expect(subject.code?(input)).to be false }
    end

    describe '.inline?' do
      it('returns false') { expect(subject.inline?(input)).to be false }
    end

    describe '.well?' do
      it('returns false') { expect(subject.well?(input)).to be false }
    end

    describe '.command?' do
      it('returns false') { expect(subject.command?(input)).to be false }
    end
  end

  context 'both inline and well, no command' do
    let(:input) { ['one `plus` two', '```lang', 'pass', '```'] }

    describe '.code?' do
      it('returns true') { expect(subject.code?(input)).to be true }
    end

    describe '.inline?' do
      it('returns true') do
        expect(subject.inline?(input.join("\n"))).to be true
      end
    end

    describe '.well?' do
      it('returns true') { expect(subject.well?(input)).to be true }
    end

    describe '.command?' do
      it('returns false') { expect(subject.command?(input)).to be false }
    end

    context 'inline only' do
      let(:input) { ['one `plus` two'] }

      describe '.code?' do
        it('returns true') { expect(subject.code?(input)).to be true }
      end

      describe '.inline?' do
        it('returns true') do
          expect(subject.inline?(input.join("\n"))).to be true
        end
      end

      describe '.well?' do
        it('returns false') { expect(subject.well?(input)).to be false }
      end

      describe '.command?' do
        it('returns false') { expect(subject.command?(input)).to be false }
      end
    end  # context: inline only

    context 'well only' do
      let(:input) { ['```lang', 'pass', '```'] }

      describe '.code?' do
        it('returns true') { expect(subject.code?(input)).to be true }
      end

      describe '.inline?' do
        it('returns false') do
          expect(subject.inline?(input.join("\n"))).to be false
        end
      end

      describe '.well?' do
        it('returns false') { expect(subject.well?(input)).to be true }
      end

      describe '.command?' do
        it('returns false') { expect(subject.command?(input)).to be false }
      end
    end  # context: well only
  end

  context 'command' do
    let(:input) { ['```lang', '$ git clone "sadf"', '```'].join("\n") }

    describe '.command?' do
      it('returns true') { expect(subject.command?(input)).to be true }
    end
  end
end # class
