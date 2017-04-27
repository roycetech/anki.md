require './bin/main_class.rb'
require 'test/unit'

BEGIN { $unit_test = true }

# Exclude the Style from Testing.
# &nbsp's are converted back to spaces just for test simplicity.
class TestSingle < Test::Unit::TestCase
  RE_OUTER_DIV = /<div class="main">[\d\D]*<\/div>/ # outer most div, won't validate mispaired divs.

  # TEST 14 - Code Front with tag newline bug
  def test_code_front_with_tag_bug
    front = ['`trace` → `nil`', '`trace2` → `nil`']
    back = ['back']
    tags = ['Multi:2']
    tag_helper = TagHelper.new(tags)

    html = HtmlHelper.new(BaseHighlighter.ruby, tag_helper, front, back)

    # Assert #1
    assert_equal(%(
<div class="main">
  <span class="tag">Multi:2</span><br>
  <code class="inline">trace</code> → <code class="inline"><span class="keyword">nil</span></code><br>
<code class="inline">trace2</code> → <code class="inline"><span class="keyword">nil</span></code>
</div>
).strip, html.front_html[RE_OUTER_DIV].gsub('&nbsp;', ' '))

    # Assert #2
    assert_equal(%(<div class="main">
  <span class="tag">Multi:2</span><br>
  back
</div>), html.back_html[RE_OUTER_DIV])
  end
end
