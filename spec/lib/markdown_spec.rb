describe Markdown do
  describe 'ITALIC Constant' do
    subject(:parser) do
      parser = SourceParser.new
      parser.regexter(
        'italic',
        Markdown::ITALIC[:regexp],
        Markdown::ITALIC[:lambda]
      )
      parser
    end

    context 'escaped underscore in function name' do
      it 'should not be tagged as italic' do
        expect(parser.parse(%q'func\_get\_args()')).to eq('func\_get\_args()')
      end
    end
  end
end
