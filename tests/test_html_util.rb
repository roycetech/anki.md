require 'test/unit'
require "./bin/main_class.rb"


BEGIN { $unit_test = true }


class TestHtmlUtil < Test::Unit::TestCase

  def test_html
    input = '<html ng-app="parking">'
    output = HtmlUtil.escape(input);
    expected = '&lt;html ng-app="parking"&gt;'    

    assert_equal(expected, output);
  end

end
