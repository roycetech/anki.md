describe OperUtils do
  describe '#xor' do
    subject(:module) {
      sut = Object.new
      sut.extend(OperUtils)
    }

    describe 'returns' do
      context 'same boolean' do
        context 'given both truthy' do
          it 'false' do
            expect(subject.xor(1, 1)).to be false
          end
        end
        context 'given both falsy' do
          it 'false' do
            expect(subject.xor(nil, nil)).to be false
          end
        end
      end

      context 'different boolean' do
        context 'given falsy, truthy' do
          it 'true' do
            expect(subject.xor(false, 1)).to be true
          end
        end
        context 'given truthy, falsy' do
          it 'true' do
            expect(subject.xor(1, nil)).to be true
          end
        end
      end
    end
  end
end
