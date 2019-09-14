require './lib/html/style_list'

describe StyleList do
  let(:base) { StyleList.new(%w[keyword quote]) }

  context 'add 1 supported' do
    subject do
      base.add('keyword', :color, 'red')
      base
    end

    it 'yields once' do
      expect { |block| subject.each(&block) }.to yield_control.exactly(1).times
    end

    it 'yields with added style' do
      subject.each do |style|
        expect(style.to_s).to eq(select('span.keyword', :color, 'red').to_s)
      end
    end
  end
end
