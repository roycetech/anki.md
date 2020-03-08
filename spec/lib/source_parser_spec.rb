require './spec/spec_helper'

describe SourceParser do
  describe '#parse' do
    context 'when entire input is matched' do
      input_string = 'abc'
      sut = SourceParser.new
      sut.regexter('name', /abc/, ->(token, _name) { "<#{token}>" })

      it 'wraps everything' do
        expect(sut.parse(input_string)).to eq('<abc>')
      end
    end
  end
end
