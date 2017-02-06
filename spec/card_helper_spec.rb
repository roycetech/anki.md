require './lib/card_helper'

describe CardHelper do
  subject { CardHelper.new 'text.md' }

  describe '#validate_tag_declaration' do
    it 'ignores non-tag' do
      expect { subject.send(:validate_tag_declaration, 'Sentence') }
        .not_to raise_error
    end

    it 'has to be case sensitive' do
      expect { subject.send(:validate_tag_declaration, '@tags: Concept') }\
        .to raise_error(RuntimeError)
    end

    it 'needs the colon:' do
      expect { subject.send(:validate_tag_declaration, '@Tags Concept') }\
        .to raise_error(RuntimeError)
    end

    it 'needs space after colon:' do
      expect { subject.send(:validate_tag_declaration, '@Tags:Concept') }\
        .to raise_error(RuntimeError)
    end
  end  # validate_tag_declaration method

  describe '#blank_or_comment?' do
    it 'returns true if spaces' do
      expect(subject.blank_or_comment?('   ')).to be true
    end

    it 'returns true if comment' do
      expect(subject.blank_or_comment?('#   ')).to be true
    end

    it 'returns true if blank' do
      expect(subject.blank_or_comment?('')).to be true
    end

    it 'returns false if tag' do
      expect(subject.blank_or_comment?('@Tags: Concept')).to be false
    end

    it 'returns false if card' do
      expect(subject.blank_or_comment?('front')).to be false
    end
  end  # blank_or_comment? method
end
