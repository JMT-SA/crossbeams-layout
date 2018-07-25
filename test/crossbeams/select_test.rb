require 'test_helper'

class Crossbeams::SelectTest < Minitest::Test
  def test_basics
    s = simple_select_render(nil, ['a', 'b'])
    assert_nil html_selected_value(s)
    assert_equal 'searchable-select', html_element_attribute_value(s, :select, :class)
    s = simple_select_render(nil, ['a', 'b'], searchable: false)
    assert_equal 'cbl-input', html_element_attribute_value(s, :select, :class)
    s = simple_select_render(nil, ['a', 'b'], disabled: true)
    assert_equal 'true', html_element_attribute_value(s, :select, :disabled)
    s = simple_select_render(nil, ['a', 'b'], selected: 'b')
    assert_equal 'b', html_selected_value(s)
    s = simple_select_render('b', ['a', 'b'])
    assert_equal 'b', html_selected_value(s)
    s = simple_select_render('c', ['a', 'b'])
    assert_nil html_selected_value(s)
    s = simple_select_render('b', ['a', 'b'], form_value: 'a')
    assert_equal 'a', html_selected_value(s)
  end

  def test_simple_option_values
    s = simple_select_render(nil, ['a', 'b'])
    assert_equal ['a', 'b'], html_select_values(s)
    s = simple_select_render(nil, ['a', 'b'])
    assert_equal ['a', 'b'], html_select_labels(s)
  end

  def test_complex_option_values
    s = simple_select_render(nil, [['a', '1'], ['b', '2']])
    assert_equal ['1', '2'], html_select_values(s)
    s = simple_select_render(nil, ['a', 'b'])
    assert_equal ['a', 'b'], html_select_labels(s)
  end

  def test_disabled_option
    s = simple_select_render(nil, ['a', 'b'], disabled_options: ['c', 'd'])
    assert_equal ['a', 'b'], html_select_values(s).sort
    assert_nil html_select_disabled_value(s)
    s = simple_select_render('c', ['a', 'b'], disabled_options: ['c', 'd'])
    assert_equal ['a', 'b', 'c'], html_select_values(s).sort
    assert_equal 'c', html_select_disabled_value(s)

    s = simple_select_render(nil, [['a', '1'], ['b', '2']], disabled_options: [['c', '3'], ['d', '4']])
    assert_equal ['1', '2'], html_select_values(s).sort
    assert_nil html_select_disabled_value(s)
    s = simple_select_render('3', [['a', '1'], ['b', '2']], disabled_options: [['c', '3'], ['d', '4']])
    assert_equal ['1', '2', '3'], html_select_values(s).sort
    assert_equal '3', html_select_disabled_value(s)
  end

  def test_prompt
    s = simple_select_render(nil, ['a', 'b'], prompt: true)
    assert_equal ['', 'a', 'b'], html_select_values(s).sort
    assert_equal ['Select a value', 'a', 'b'], html_select_labels(s)

    s = simple_select_render(nil, ['a', 'b'], prompt: 'MAKE A CHOICE')
    assert_equal ['', 'a', 'b'], html_select_values(s).sort
    assert_equal ['MAKE A CHOICE', 'a', 'b'], html_select_labels(s)
  end

  # optgroups - [[1,2,3], [1,4,5]] OR { 1 => [[2,3], [4,5]] } OR  { 1 => [[1,2,3], [1,4,5]] }

end
