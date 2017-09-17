require'./bin/main_class.rb'
require 'test/unit'

BEGIN { $unit_test = true }

# Exclude the Style from Testing.
# &nbsp's are converted back to spaces just for test simplicity.
class TestCodeDetector < Test::Unit::TestCase
  def test_no_code
    array = ['card']
    assert_equal(false, CodeDetector.has_code?(array))
  end

  def test_inline_code
    array = ['`card`']
    assert_equal(true, CodeDetector.has_code?(array))
  end

  def test_inline_escaped
    array = ['`car\`d`']
    assert_equal(true, CodeDetector.has_code?(array))
  end

  def test_inline_within
    array = ['pre `card` after']
    assert_equal(true, CodeDetector.has_code?(array))
  end

  def test_inline_last
    array = ['first', 'pre `card` after']
    assert_equal(true, CodeDetector.has_code?(array))
  end

  def test_inline_middle
    array = ['first', 'pre `card` after', 'last']
    assert_equal(true, CodeDetector.has_code?(array))
  end

  def test_well
    array = ['first', '````', 'code inside well', '```', 'last']
    assert_equal(true, CodeDetector.has_code?(array))
  end
end
