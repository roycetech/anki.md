class ReviewerPrinter
  def initialize(reviewer)
    @reviewer = reviewer
  end

  # :nocov:
  def print_multi
    count_regex = /\((\d*)\)/
    @reviewer.all_multi.sort! do |a, b|
      a[count_regex, 1].to_i <=> b[count_regex, 1].to_i
    end
    puts(format("Multi Tags: %s\n\n", @reviewer.all_multi.to_s))
  end

  def print_card_count
    puts(format('Total cards: %s', @reviewer.all_front.size))
  end

  def print_sellout
    puts(format("Sellout: %s\n", @reviewer.all_sellout.to_s))
  end

  def print_duplicate
    dups = @reviewer.all_front.select { |e| @reviewer.all_front.count(e) > 1 }\
                    .uniq.to_s

    puts(format("Potential Duplicates: %s\n", dups))
  end

  def print_all
    print_sellout
    print_duplicate
    print_card_count
    print_multi
  end
  # :nocov:
end
