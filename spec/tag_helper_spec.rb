require './lib/tag_helper'

describe TagHelper do
  describe '#initialize' do
    describe 'empty tags' do
      subject { TagHelper.new(tags: []) }
      it 'is untagged' do
        expect(subject.untagged?).to be true
      end
    end

    describe 'tagged' do
      subject { TagHelper.new(tags: [:Concept]) }
      it 'is not untagged' do
        expect(subject.untagged?).to be false
      end
    end

    it 'accepts :tags parameter' do
      expect { TagHelper.new(tags: [:Concept]) }.not_to raise_error
    end

    it 'accepts :tag_line parameter' do
      expect { TagHelper.new(tag_line: '@Tags: Concept') }.not_to raise_error
    end

    describe 'raises an error' do
      it 'rejects parameter if both :tags and :tag_line parameter provided' do
        expect { TagHelper.new(tags: 1, tag_line: 1) }.to \
          raise_error(AssertionError)
      end

      it 'rejects parameter if neither :tags nor :tag_line param provided' do
        expect { TagHelper.new }.to raise_error(AssertionError)
      end

      it 'rejects parameter if tags: is not list of symbols' do
        expect { TagHelper.new(tags: ['Concept']) }.to \
          raise_error(AssertionError)
      end
    end

    context 'non-list' do
      subject { TagHelper.new(tag_line: '@Tags: Concept') }

      it 'include ":Concept"' do
        expect(subject.include?(:Concept)).to be true
      end

      it 'include visible tag ":Concept"' do
        expect(subject.visible_tags).to include(:Concept)
      end

      its(:ul?) { should be false }
      its(:ol?) { should be false }
      its(:enum?) { should be false }
      its(:figure?) { should be false }

      context 'double-sided' do
        its(:one_sided?) { should be false }
        its(:back_only) { should be false }
        its(:front_only) { should be false }
      end

      context 'one-sided' do
        context 'Front Only' do
          subject { TagHelper.new(tag_line: '@Tags: FB') }
          its(:one_sided?) { should be true }
          its(:front_only) { should be true }
          its(:back_only) { should be false }

          it 'exclude invisible tag ":FB"' do
            expect(subject.visible_tags).not_to include(:Concept)
          end
        end

        context 'Back Only' do
          subject { TagHelper.new(tag_line: '@Tags: BF') }
          its(:one_sided?) { should be true }
          its(:front_only) { should be false }
          its(:back_only) { should be true }

          it 'exclude invisible tag ":FB"' do
            expect(subject.visible_tags).not_to include(:BF)
          end
        end
      end

      context 'Figure' do
        subject { TagHelper.new(tag_line: '@Tags: Figure ☖') }
        its(:figure?) { should be true }
      end
    end  # context non-list

    context 'list' do
      context 'unordered' do
        subject { TagHelper.new(tags: [:EnumU]) }
        its(:ul?) { should be true }
        its(:ol?) { should be false }
        its(:enum?) { should be true }
        its(:figure?) { should be false }
        its(:one_sided?) { should be true }
        its(:back_only) { should be false }
        its(:front_only) { should be true }
      end

      context 'ordered' do
        subject { TagHelper.new(tags: [:EnumO]) }
        its(:ul?) { should be false }
        its(:ol?) { should be true }
        its(:enum?) { should be true }
        its(:figure?) { should be false }
        its(:one_sided?) { should be true }
        its(:back_only) { should be false }
        its(:front_only) { should be true }
      end
    end  # end context-list
  end  # method

  describe '#add' do
    subject { TagHelper.new(tags: [:Concept]) }
    it 'should include added tag' do
      expect { subject.add(:FB) }.to \
        change { subject.include?(:FB) }.from(false).to(true)
    end
  end  # #add method

  describe '#index_enum' do
    subject { TagHelper.new(tags: [:EnumU]) }
    describe 'given 2 cards' do
      let(:cards) { %w(card1 card2) }

      it 'removes "EnumU"' do
        expect { subject.index_enum(cards) }.to \
          change { subject.include?(:EnumU) }.from(true).to(false)
      end

      it 'adds "EnumU:2"' do
        expect { subject.index_enum(cards) }.to \
          change { subject.include?(:'EnumU:2') }.from(false).to(true)
      end
    end
  end  # #add method
end # class
