require './lib/dsl/selector_dsl'

describe SelectorDSL do
  describe 'supports blocks' do
    subject(:dsl) do
      select 'div.main' do
        color 'white'
        text_align 'left'
      end
    end

    let(:first) { :color }
    let(:second) { :'text-align' }

    it 'is fixed indented' do
      expect(dsl.to_s).to eq(
        [
          '  div.main {',
          '    color: white;',
          '    text-align: left;',
          '  }'
        ].join("\n")
      )
    end

    describe 'style names' do
      let(:styles_hash) { dsl.styles_hash }

      it 'hash contains added' do
        expect(styles_hash.keys).to include(first)
      end

      it 'hash converts underscore to dash' do
        expect(styles_hash.keys).to include(second)
      end

      it 'list contains added' do
        expect(styles_hash.keys).to include(first)
      end

      it 'list contains converted property name' do
        expect(styles_hash.keys).to include(second)
      end
    end

    describe 'style values' do
      it 'contains added' do
        expect(dsl.styles_hash[first]).to include('white')
        expect(dsl.styles_hash[second]).to include('left')
      end
    end
  end  # context: supportsblocks

  describe 'supports single line' do
    subject(:dsl) do
      select 'span.tag', :color, :white
    end

    it 'passes' do
      expect(subject.to_s).to eq('  span.tag { color: white; }')
    end
  end  # context: suports single line
end # class
