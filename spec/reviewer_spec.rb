require './lib/reviewer'

describe Reviewer do
  describe '#detect_sellouts' do
    describe 'positive detection' do
      let(:front) { ['front'] }
      let(:back) { ['I am front hiding in back'] }

      it 'detects' do
        expect { subject.detect_sellouts(front, back) }\
          .to change { subject.all_sellout }.from([]).to([front[0]])
      end
    end

    describe 'negative detection' do
      let(:front) { ['front'] }
      let(:back) { ['I am not coddling in back'] }

      it 'is silent' do
        expect { subject.detect_sellouts(front, back) }
          .not_to change { subject.all_sellout }
      end
    end
  end # detect_sellouts method

  describe '#count_sentence' do
    context 'back only' do
      let(:front) { ['front'] }

      context 'Syntax' do
        let(:back) { ['back.to_s; s.print'] }
        let(:tag_helper) { TagHelper.new(tags: [:Syntax]) }

        it 'is counted as one' do
          expect { subject.count_sentence(tag_helper, front, back) }\
            .not_to change { subject.all_multi }
        end
      end

      context 'tags are irrelevant' do
        let(:tag_helper) { TagHelper.new(tags: []) }

        context 'java package' do
          let(:back) { ['a java.util.Map'] }

          it 'is not considered multi-sentence' do
            expect { subject.count_sentence(tag_helper, front, back) }
              .not_to change { subject.all_multi }
          end
        end

        describe 'Multi sentence, ended with non-dot' do
          let(:back) { ['I love you. You love me'] }
          it 'is detected' do
            expect { subject.count_sentence(tag_helper, front, back) }\
              .to change { subject.all_multi }.from([]).to(["#{front.join}(2)"])
          end
        end

        describe 'Multi sentence, ended with dot' do
          let(:back) { ['I love you. You love me.'] }
          it 'is detected' do
            expect { subject.count_sentence(tag_helper, front, back) }
              .to change { subject.all_multi }
              .from([])
              .to(["#{front.join}(2)"])
          end
        end
      end # context: 'tags are irrelevant'
    end # context: back only
  end # count_sentence

  describe '#create_tag' do
    context 'sentence count no more than 1' do
      it 'returns nil' do
        expect(subject.create_tag(1, nil, nil)).to be nil
      end
    end
    context 'enum' do
      it 'returns nil' do
        expect(subject.create_tag(2, TagHelper.new(tags: [:EnumU]), nil))\
          .to be nil
      end
    end
  end
end # end class
