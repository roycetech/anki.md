require './lib/tag_counter'

describe TagCounter do
  context 'given two "Concept" tagged cards' do
    let(:filename) { 'testdummy.md' }

    require 'stringio'

    let(:file) do
      file = StringIO.new([
        '@Tags: Concept',
        'front1',
        '',
        'back1',
        '',
        '',
        '@Tags: Concept',
        'front2',
        '',
        'back2'
      ].join("\n"))
      allow(file).to receive(:path) { filename }
      file
    end

    context 'calls verification' do
      it 'invokes #register_tags twice' do
        expect(subject).to receive(:register_tags).twice
        subject.count_tags(file)
      end
    end

    context 'counter pre-executed' do
      let(:tag_counter) do
        subject.count_tags(file)
        subject
      end

      it 'keeps a hash of tag and its count' do
        expect(tag_counter.tags_count).to eq(Concept: 2)
      end
    end
  end # Context: 'given two "Concept" tagged cards'
end # class
