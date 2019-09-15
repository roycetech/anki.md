require './spec/spec_helper'
require './lib/meta_reader'

describe MetaReader do
  input_filename = './spec/data/file1_spec.txt'

  describe '#read' do
    it 'returns a map with key-value pair "lang=js"' do
      File.open(input_filename, 'r') do |file|
        double('file')
        meta_map = MetaReader.read(file)
        expect(meta_map[:lang]).to eq('js')
      end
    end

    it 'rewinds file pointer' do
      File.open(input_filename, 'r') do |_file|
        mfile = double('file')
        allow(mfile).to receive(:gets)
        expect(mfile).to receive(:rewind)
        MetaReader.read(mfile)
      end
    end
  end
end
