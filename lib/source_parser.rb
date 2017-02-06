# This class is designed to parse a string token only once until no more regexp
# can parse it.
#
# regexp name will serve as better ID for readability.
# Abbreviations:
# processed -> procd
class SourceParser
  def initialize
    @regexp_lambda = {}
    @regexp_name = {}
  end

  # Register a regular expression.  Omit 3rd parameter to preserve the match
  def regexter(name, regexp, lambda = ->(ltoken, _lregexp) { ltoken })
    @regexp_name[regexp] = name
    @regexp_lambda[regexp] = lambda
  end

  def parse(text)
    assert @regexp_name.any?,
           message: 'You must regexter a lambda to handle a regexp match'

    procd_array = [text]
    procdflag_array = [false]

    loop do
      found = false
      procd_array.each_with_index do |element, index|
        next if procdflag_array[index]

        map = check_pattern(element)
        partition = map[:partition]

        next if partition_missed(partition)
        lambda = map[:lambda]
        regexp = map[:regexp]
        procd = lambda.call(partition[1], regexp)

        found = true
        if partition_begin(partition)
          handle_begin(index, procd, procd_array, procdflag_array, partition)
        elsif partition_mid(partition)
          handle_middle(index, procd, procd_array, procdflag_array, partition)
        elsif partition_end(partition)
          procd_array[index] = procd
          procdflag_array[index] = true
          procd_array.insert(index, partition[0])
          procdflag_array.insert(index, false)
        elsif partition_all(partition)
          procd_array[index] = procd
          procdflag_array[index] = true
        end
        break
      end # array each block

      break unless found
    end
    procd_array.inject('') { |a, e| a + e }
  end

  def handle_begin(index, procd, procd_array, procdflag_array, partition)
    procd_array[index] = partition[2]
    procdflag_array[index] = false
    procd_array.insert(index, procd)
    procdflag_array.insert(index, true)

    procd_array.replace(procd_array)
    procdflag_array.replace(procdflag_array)
  end

  def handle_middle(index, procd, procd_array, procdflag_array, partition)
    procd_array[index] = partition[2]
    procd_array.insert(index, procd)
    procdflag_array.insert(index, true)
    procd_array.insert(index, partition[0])
    procdflag_array.insert(index, false)

    procd_array.replace(procd_array)
    procdflag_array.replace(procdflag_array)
  end

  alias format parse

  # Returns a tuple partition as array, and the matching lambda
  def check_pattern(string)
    return_value = {}
    @regexp_lambda.each do |pattern, proc|
      return_value[:partition] = string.partition(pattern)
      return_value[:lambda] = proc
      return_value[:regexp_name] = @regexp_name[pattern]
      return_value[:regexp] = pattern
      break unless partition_missed(return_value[:partition])
    end

    return_value.delete(:lambda) if partition_missed(return_value[:partition])
    return_value
  end

  def partition_missed(array)
    _partition_common(array, false, true, true)
  end

  def partition_begin(array)
    _partition_common(array, true, false, false)
  end

  def partition_mid(array)
    _partition_common(array, false, false, false)
  end

  def partition_end(array)
    _partition_common(array, false, false, true)
  end

  def partition_all(array)
    _partition_common(array, true, false, true)
  end

  # pass false if it is !empty?
  def _partition_common(array, bon, boo, bri)
    array[0].empty? == bon && array[1].empty? == boo && array[2].empty? == bri
  end
end
