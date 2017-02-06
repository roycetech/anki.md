require './lib/assert'

describe Assert do
  describe '#assert' do
    subject(:module) do
      sut = Object.new
      sut.extend(Assert)
    end

    it 'raises AssertionError if false' do
      expect do
        subject.assert(false, message: 'Error')
      end.to raise_error(Assert::AssertionError)
    end

    it 'is silent if expr is truthy' do
      expect do
        subject.assert(true, message: 'Impossible to error')
      end.not_to raise_error
    end
  end
end
