require './lib/system_tag_counter'

describe SystemTagCounter do
  describe '#count' do
    context 'untagged' do
      let(:tag_helper) { TagHelper.new(tags: []) }

      it 'returns "untagged"' do
        expect(subject.count(tag_helper, map: nil)).to eq(:untagged.to_s)
      end
    end

    context 'single tag' do
      context 'sole tag in deck' do
        let(:tag_helper) { TagHelper.new(tags: [:Concept]) }
        let(:map) { { Concept: 1, Enum: 5 } }

        it 'appends the index' do
          expect(subject.count(tag_helper, map: map)).to eq('Concept')
        end
      end

      context '1 of 2 tags in deck' do
        let(:tag_helper) { TagHelper.new(tags: [:Concept]) }
        let(:map) { { Concept: 2, Enum: 5 } }

        it 'appends the index' do
          expect(subject.count(tag_helper, map: map)).to eq('Concept(2)')
        end
      end
    end
  end # count()
end # class
