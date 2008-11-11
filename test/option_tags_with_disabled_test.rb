require 'test_helper'

class FormOptionsHelperTest < ActionView::TestCase
  tests ActionView::Helpers::FormOptionsHelper

  test "options for select with disabled value" do
    assert_dom_equal(
      "<option value=\"Denmark\">Denmark</option>\n<option value=\"&lt;USA&gt;\" disabled=\"disabled\">&lt;USA&gt;</option>\n<option value=\"Sweden\">Sweden</option>",
      options_for_select([ "Denmark", "<USA>", "Sweden" ], [],"<USA>")
    )
  end

  test "options for select with multiple disabled" do
    assert_dom_equal(
      "<option value=\"Denmark\">Denmark</option>\n<option value=\"&lt;USA&gt;\" disabled=\"disabled\">&lt;USA&gt;</option>\n<option value=\"Sweden\" disabled=\"disabled\">Sweden</option>",
      options_for_select([ "Denmark", "<USA>", "Sweden" ], [],["<USA>", "Sweden"])
    )
  end

  test "options for select with selection and disabled value" do
    assert_dom_equal(
      "<option value=\"Denmark\" selected=\"selected\">Denmark</option>\n<option value=\"&lt;USA&gt;\" disabled=\"disabled\">&lt;USA&gt;</option>\n<option value=\"Sweden\">Sweden</option>",
      options_for_select([ "Denmark", "<USA>", "Sweden" ], "Denmark","<USA>")
    )
  end

end
