require './lib/html/html_class_finder'

describe HtmlClassFinder do
  describe '#find' do
    subject { Object.new.extend(HtmlClassFinder) }

    let(:no_html) { 'no' }
    let(:no_class) { '<span>input</span>' }
    let(:with_class) { '<span class="tag">input</span>' }
    let(:many_class) do
      [
        '<span class="tag">input</span>',
        '<div class="key">input</div>',
        '<div class="key quote">input</div>'
      ].join("\n")
    end

    it 'returns an empty array if no html' do
      expect(subject.find(no_html, 'span')).to eq([])
    end

    it 'returns an empty array if none is found' do
      expect(subject.find(no_class, 'span')).to eq([])
    end

    it 'finds only for given element name' do
      expect(subject.find(with_class, 'tag')).to eq([])
    end

    it 'can find multiple tags' do
      expect(subject.find(many_class, 'div')).to eq(%w(key quote))
    end

    it 'returns unqiue tags' do
      expect(subject.find(many_class, 'div')).to eq(%w(key quote))
    end

    it 'returns an array of class if found' do
      expect(subject.find(with_class, 'span')).to eq(['tag'])
    end
  end
end
