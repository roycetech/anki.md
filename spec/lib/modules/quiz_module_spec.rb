require './lib/modules/quiz_module'
require './spec/dummy_class'

describe QuizModule do
  let(:dummy) do
    dummy = DummyClass.new
    dummy.extend(described_class)
    dummy
  end

  subject { dummy }

  describe '#quiz?' do
    describe 'initial invocation' do
      it 'sets the value of the instance variable @quiz' do
        allow(subject).to receive(:quiz_choice?) { true }

        subject.quiz?
        expect(subject.instance_variable_get(:@quiz)).to be(true)
      end
    end
  end

  describe '#quiz_choice?' do
    describe 'initial invocation' do
      it 'sets the value of the instance variable @choice' do
        allow(subject).to receive(:quiz_single_choice?) { true }
        subject.quiz_choice?
        expect(subject.instance_variable_get(:@choice)).to be(true)
      end
    end
  end

  describe '#quiz_multi_choice?' do
    subject { dummy.quiz_multi_choice?(param) }

    context 'when passed nil' do
      let(:param) { nil }

      it { should be false }
    end

    context 'when passed non-Array' do
      let(:param) { 'string' }

      it { should be false }
    end

    context 'when passed empty Array' do
      let(:param) { [] }

      it { should be false }
    end

    context 'when passed Array, non-checked' do
      let(:param) { ['[] Yo'] }

      it { should be false }
    end

    context 'when passed Array, one checked' do
      let(:param) { ['[x] Yo'] }

      it { should be true }
    end

    context 'when passed Array, two checked' do
      let(:param) do
        [
          '[x] one',
          '[x] two',
          '[] three'
        ]
      end

      it { should be true }
    end

    context 'when passed Array, all checked' do
      let(:param) do
        [
          '[x] one',
          '[x] two'
        ]
      end

      it { should be true }
    end
  end

  describe '#quiz_single_choice?' do
    subject { dummy.quiz_single_choice?(param) }

    context 'when passed nil' do
      let(:param) { nil }

      it { should be false }
    end

    context 'when passed non-Array' do
      let(:param) { 'string' }

      it { should be false }
    end

    context 'when passed empty Array' do
      let(:param) { [] }

      it { should be false }
    end

    context 'when passed Array, non-checked' do
      let(:param) { ['() Yo'] }

      it { should be false }
    end

    context 'when passed Array, one checked' do
      let(:param) { ['(x) Yo'] }

      it { should be true }
    end

    context 'when passed Array, two checked' do
      let(:param) do
        [
          '(x) one',
          '(x) two',
          '() three'
        ]
      end

      it { should be false }
    end

    context 'when passed Array, all checked' do
      let(:param) do
        [
          '(x) one',
          '(x) two'
        ]
      end

      it { should be false }
    end
  end

  describe '#quiz_fill_blank?' do
    subject { dummy.quiz_multi_choice?(param) }

    context 'happy path' do
      let(:param) { 'The name of the game is _____, correct?' }

      it { should be true }
    end
  end
end


