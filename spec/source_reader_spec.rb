require './lib/source_reader'

#
describe SourceReader do
  describe '#each_card' do
    let(:filename) { 'testdummy.md' }

    require 'stringio'

    context 'single card' do
      let(:front) { 'front' }
      let(:back) { 'back' }

      subject(:reader) do
        file = StringIO.new([
          front,
          '',
          back
        ].join("\n"))
        allow(file).to receive(:path) { filename }
        SourceReader.new(file)
      end

      it 'yields once' do
        expect { |b| subject.each_card(&b) }.to yield_control
      end

      it 'yields the cards' do
        expect { |b| subject.each_card(&b) }
          .to yield_with_args([[], [front], [back]])
      end
    end  # context: single-card

    context 'double card' do
      let(:front1) { 'front1' }
      let(:back1) { 'back1' }
      let(:front2) { 'front2' }
      let(:back2) { 'back2' }

      subject(:reader) do
        file = StringIO.new([
          front1,
          '',
          back1,
          '',
          '',
          front2,
          '',
          back2
        ].join("\n"))
        allow(file).to receive(:path) { filename }
        SourceReader.new(file)
      end

      it 'yields twice' do
        expect { |b| subject.each_card(&b) }.to yield_control.twice
      end

      it 'yields the cards' do
        expect { |b| subject.each_card(&b) }.to \
          yield_successive_args(
            [
              [],
              [front1],
              [back1]
            ],
            [
              [],
              [front2],
              [back2]
            ]
          )
      end
    end  # context: double-card

    context 'with tag' do
      let(:front1) { 'front1' }
      let(:back1) { 'back1' }
      let(:front2) { 'front2' }
      let(:back2) { 'back2' }
      let(:tags) { %i(Concept Abbr) }

      subject(:reader) do
        file = StringIO.new(
          [
            '@Tags: Abbr',
            front1,
            '',
            back1,
            '',
            '',
            '@Tags: Concept',
            front2,
            '',
            back2
          ].join("\n")
        )
        allow(file).to receive(:path) { filename }
        SourceReader.new(file)
      end

      context 'with "Abbr" tag' do
        it 'appends "Abbreviation to the front card"' do
          expect { |b| subject.each_card(&b) }.to \
            yield_successive_args(
              [
                [:Abbr],
                [front1 + ' abbreviation'],
                [back1]
              ],
              [
                [:Concept],
                [front2],
                [back2]
              ]
            )
        end
      end
    end  # context: with tag
  end # each_card()
end # class
