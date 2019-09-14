require 'test/unit'

BEGIN { $unit_test = true }

# Exclude the Style from Testing.
# &nbsp's are converted back to spaces just for test simplicity.
class TestHtmlHelper < Test::Unit::TestCase
  RE_OUTER_DIV = %r{<div class="main">[\d\D]*</div>}.freeze # outer most div, won't validate mispaired divs.

  # TEST 1
  def test_php_tagless_single
    front = ['front']
    back = ['back']
    tags = []

    tag_helper = TagHelper.new(tags)

    html = HtmlHelper.new(BaseHighlighter.php, tag_helper, front, back)

    # Assert #1
    assert_equal(%(<div class="main">
  front
</div>), html.front_html[RE_OUTER_DIV])

    # Assert #2
    assert_equal(%(<div class="main">
  back
</div>), html.back_html[RE_OUTER_DIV])
  end

  # TEST 2
  def test_php_tagged_single
    front = ['front']

    back = '```
function ífunctionNameí(íparamsí) {
  // stmts
}
```'.lines.collect(&:rstrip)

    tags = ['Syntax']

    tag_helper = TagHelper.new(tags)

    html = HtmlHelper.new(BaseHighlighter.php, tag_helper, front, back)

    # Assert #1
    assert_equal(%(
<div class="main">
  <span class="tag">Syntax</span><br>
  front
</div>
).strip, html.front_html[RE_OUTER_DIV])

    # Assert #2
    assert_equal(%'
<div class="main">
  <div class="well"><code>
<span class="keyword">function</span> <i>functionName</i>(<i>params</i>) {<br>
  <span class="comment">// stmts</span><br>
}
  </code></div>
  <span class="answer_only">Answer Only</span>
</div>
'.strip, html.back_html[RE_OUTER_DIV].gsub('&nbsp;', ' '))
  end

  # TEST 3
  def test_php_anon_function
    front = ['front']

    back = '
```
$x = 1;
$f = function() use($x) {
  // stmts
};
```
'.lines.collect(&:rstrip)

    tags = ['Syntax']
    tag_helper = TagHelper.new(tags)
    html = HtmlHelper.new(BaseHighlighter.php, tag_helper, front, back)

    # Assert #1
    assert_equal(%(
<div class="main">
  <span class="tag">Syntax</span><br>
  front
</div>
).strip, html.front_html[RE_OUTER_DIV])

    # Assert #2
    assert_equal(%'
<div class="main">
  <div class="well"><code>
<span class="var">$x</span> = 1;<br>
<span class="var">$f</span> = <span class="keyword">function</span>() <span class="keyword">use</span>(<span class="var">$x</span>) {<br>
  <span class="comment">// stmts</span><br>
};
  </code></div>
  <span class="answer_only">Answer Only</span>
</div>
'.strip, html.back_html[RE_OUTER_DIV].gsub('&nbsp;', ' '))
  end

  # TEST 4
  def test_php_keyword_in_noncode
    front = ['front']
    back = ['To declare the `global`.']

    tags = []
    tag_helper = TagHelper.new(tags)
    html = HtmlHelper.new(BaseHighlighter.php, tag_helper, front, back)

    # Assert #1
    assert_equal(%(
<div class="main">
  front
</div>
).strip, html.front_html[RE_OUTER_DIV])

    # Assert #2
    assert_equal(%(
<div class="main">
  To declare the <code class="inline"><span class="keyword">global</span></code>.
</div>
).strip, html.back_html[RE_OUTER_DIV].gsub('&nbsp;', ' '))
  end

  # TEST 5
  def test_php_keyword_in_noncode_with_well
    front = ['front']
    back = %(
To declare the `global`.
Example:
```
global $globalvar;
```
).lines.collect(&:rstrip)
    tags = ['Syntax']

    tag_helper = TagHelper.new(tags)
    html = HtmlHelper.new(BaseHighlighter.php, tag_helper, front, back)

    # Assert #1
    assert_equal(%(
<div class="main">
  <span class="tag">Syntax</span><br>
  front
</div>
).strip, html.front_html[RE_OUTER_DIV])

    # Assert #2
    assert_equal(%(
<div class="main">
  To declare the <code class="inline"><span class="keyword">global</span></code>.
Example:
<div class="well"><code>
<span class="keyword">global</span> <span class="var">$globalvar</span>;
  </code></div>
  <span class="answer_only">Answer Only</span>
</div>
).strip, html.back_html[RE_OUTER_DIV].gsub('&nbsp;', ' '))
  end

  # TEST 6, Detect codes by inline or wells, not by tags.
  def test_php_tag_independent_codes
    front = ['front']
    back = %(
Example:
```
echo $GLOBAL['glovar'];
```
).lines.collect(&:rstrip)
    tags = ['Practical']

    tag_helper = TagHelper.new(tags)
    html = HtmlHelper.new(BaseHighlighter.php, tag_helper, front, back)

    # Assert #1
    assert_equal(%(
<div class="main">
  <span class="tag">Practical</span><br>
  front
</div>
).strip, html.front_html[RE_OUTER_DIV])

    # Assert #2
    assert_equal(%(
<div class="main">
  Example:
<div class="well"><code>
<span class="keyword">echo</span> <span class="var">$GLOBAL</span>[<span class="quote">'glovar'</span>];
  </code></div>
  <span class="answer_only">Answer Only</span>
</div>
).strip, html.back_html[RE_OUTER_DIV].gsub('&nbsp;', ' '))
  end

  # TEST 7
  def test_php_keyword_in_noncode
    front = ['front']
    back = ['back']

    tags = ['Practical']
    tag_helper = TagHelper.new(tags)
    html = HtmlHelper.new(BaseHighlighter.php, tag_helper, front, back)

    # Assert #1
    assert_equal(%(
<div class="main">
  <span class="tag">Practical</span><br>
  front
</div>
).strip, html.front_html[RE_OUTER_DIV])

    # Assert #2
    assert_equal(%(
<div class="main">
  back<br>
<br>
  <span class="answer_only">Answer Only</span>
</div>
).strip, html.back_html[RE_OUTER_DIV].gsub('&nbsp;', ' '))
  end

  # TEST 8
  def test_tag_above_backcard
    front = ['front']
    back = ['back']

    tags = ['Function']
    tag_helper = TagHelper.new(tags)
    html = HtmlHelper.new(BaseHighlighter.php, tag_helper, front, back)

    # Assert #1
    assert_equal(%(
<div class="main">
  <span class="tag">Function</span><br>
  front
</div>
).strip, html.front_html[RE_OUTER_DIV])

    # Assert #2
    assert_equal(%(
<div class="main">
  <span class="tag">Function</span><br>
  back
</div>
).strip, html.back_html[RE_OUTER_DIV].gsub('&nbsp;', ' '))
  end

  # TEST 9
  def test_tag_above_backcard_multi
    front = ['front']
    back = ['back', 'to back']

    tags = ['Function']
    tag_helper = TagHelper.new(tags)
    html = HtmlHelper.new(BaseHighlighter.php, tag_helper, front, back)

    # Assert #1
    assert_equal(%(
<div class="main">
  <span class="tag">Function</span><br>
  front
</div>
).strip, html.front_html[RE_OUTER_DIV])

    # Assert #2
    assert_equal(%(
<div class="main">
  <span class="tag">Function</span><br>
  back
to back
</div>
).strip, html.back_html[RE_OUTER_DIV].gsub('&nbsp;', ' '))
  end

  # TEST 10 - Test no extra space between the code and the answer only.
  def test_backcard_single_code_fb
    front = ['front']
    back = ['`null`']

    tags = ['Practical']
    tag_helper = TagHelper.new(tags)
    html = HtmlHelper.new(BaseHighlighter.php, tag_helper, front, back)

    # Assert #1
    assert_equal(%(
<div class="main">
  <span class="tag">Practical</span><br>
  front
</div>
).strip, html.front_html[RE_OUTER_DIV])

    # Assert #2
    assert_equal(%(
<div class="main">
  <code class="inline">null</code><br>
<br>
  <span class="answer_only">Answer Only</span>
</div>
).strip, html.back_html[RE_OUTER_DIV].gsub('&nbsp;', ' '))
  end

  # TEST 11 - Test no extra space between the code and the answer only.
  def test_web_script_tag_bug
    front = ['front']
    back = ['```', '<script src="ífilename.jsí"></script>', '```']

    tags = ['Practical']
    tag_helper = TagHelper.new(tags)
    html = HtmlHelper.new(BaseHighlighter.web, tag_helper, front, back)

    # Assert #1
    assert_equal(%(
<div class="main">
  <div class="well"><code>
<span class="html">&lt;script</span> <span class="attr">src</span>=<span class="quote">"<i>filename.js</i>"</span>&gt;<span class="html">&lt;/script&gt;</span>
  </code></div>
  <span class="answer_only">Answer Only</span>
</div>
).strip, html.back_html[RE_OUTER_DIV].gsub('&nbsp;', ' '))
  end

  # TEST 12 - Test to wrap html attributes with span with class
  def test_web_script_attribute
    front = ['front']
    back = ['```', '<script src="2" checked test="12"></script>', '```']
    tags = []
    tag_helper = TagHelper.new(tags)
    html = HtmlHelper.new(BaseHighlighter.web, tag_helper, front, back)

    # Assert #1
    assert_equal(%(
<div class="main">
  <div class="well"><code>
<span class="html">&lt;script</span> <span class="attr">src</span>=<span class="quote">"2"</span> <span class="attr">checked</span> <span class="attr">test</span>=<span class="quote">"12"</span>&gt;<span class="html">&lt;/script&gt;</span>
  </code></div>
</div>
).strip, html.back_html[RE_OUTER_DIV].gsub('&nbsp;', ' '))
  end

  # TEST 13 - Code, Multiline
  def test_multiline_code
    front = ['`trace` → `nil`', '`trace2` → `nil`']
    back = ['back']
    tags = []
    tag_helper = TagHelper.new(tags)

    html = HtmlHelper.new(BaseHighlighter.ruby, tag_helper, front, back)

    # Assert #1
    assert_equal(%(
<div class="main">
  <code class="inline">trace</code> → <code class="inline"><span class="keyword">nil</span></code><br>
<code class="inline">trace2</code> → <code class="inline"><span class="keyword">nil</span></code>
</div>
).strip, html.front_html[RE_OUTER_DIV].gsub('&nbsp;', ' '))

    # Assert #2
    assert_equal(%(<div class="main">
  back
</div>), html.back_html[RE_OUTER_DIV])
  end

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
