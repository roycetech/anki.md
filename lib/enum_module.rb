# enum type of cards related functionalities
module EnumModule
  def enum?
    ul? || ol?
  end

  def ol?
    @enum == :EnumO
  end

  def ul?
    @enum == :EnumU
  end

  def enum_detected?(back_card)
    front_only_orig = @front_only
    @front_only = true

    if back_card.is_a?(Array) && back_card.any?
      return true if ordered_enum?(back_card)

      back_card.each { |element| return false unless element[/^[-+*]\s.*/] }

      return false unless enum_same_prefix?(back_card)

      @enum = :EnumU
      return true
    end
    @front_only = front_only_orig
    false
  end

  def ordered_enum?(back_card)
    back_card.each_with_index do |item, index|
      return false unless item.start_with?("#{index + 1}. ")
    end
    @enum = :EnumO
    true
  end

  def trim_enum_markdown(back_card)
    if ordered_enum?(back_card)
      return back_card.collect { |item| item.gsub(/^\d+\.\s/, '') }
    end

    back_card.collect do |item|
      item.gsub(/^[-*+] /, '')
    end
  end

  private

  def enum_same_prefix?(back_card)
    prefix = back_card.first[0, 2]
    back_card_rest = back_card - [back_card.first]
    back_card_rest.all? { |list_item| list_item.start_with?(prefix) }
  end
end
