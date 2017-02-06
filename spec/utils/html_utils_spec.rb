require './spec/spec_helper'

describe HtmlUtils do
  subject do
    sut = Object.new
    sut.extend(HtmlUtils)
  end

  describe '1. #escape_spaces' do
    it 'ignores space between words' do
      expect(subject.escape_spaces('one two')).to eq('one two')
    end

    it 'converts leading spaces' do
      expect(subject.escape_spaces('  <span class="quote">')).to \
        eq('&nbsp;&nbsp;<span class="quote">')
    end

    it 'converts spaces between tags' do
      expect(subject.escape_spaces('</span>  <span class="quote">')).to \
        eq('</span>&nbsp;&nbsp;<span class="quote">')
    end
  end  # 1. #escape_spaces

  describe '2. #escape_spaces!' do
    let(:betwee_words) { 'Hello World' }
    it 'ignores space between words' do
      expect { subject.escape_spaces!(betwee_words) }.not_to \
        change { betwee_words }
    end

    let(:leading) { '  <span class="quote">' }
    it 'converts leading spaces' do
      expect { subject.escape_spaces!(leading) }.to \
        change { leading }\
        .from('  <span class="quote">')\
        .to('&nbsp;&nbsp;<span class="quote">')
    end

    let(:between_angles) { '</span>  <span class="quote">' }
    it 'converts spaces between angles' do
      expect { subject.escape_spaces!(between_angles) }.to \
        change { between_angles }\
        .from('</span>  <span class="quote">')\
        .to('</span>&nbsp;&nbsp;<span class="quote">')
    end
  end  # 2. #escape_spaces!

  describe '3. #wrap' do
    let(:without_tag) { [:quote, 'text'] }
    it 'wraps in span with class, given no tag' do
      expect(subject.wrap(*without_tag)).to \
        eq('<span class="quote">text</span>')
    end

    let(:with_tag) { [:attr, 'text', :div] }
    it 'wraps in given tag with class' do
      expect(subject.wrap(*with_tag)).to eq('<div class="attr">text</div>')
    end
  end  # 3. #span
end # class
