require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutBlocks < Neo::Koan
  def method_with_block
    result = yield
    result
  end

  def test_methods_can_take_blocks
    yielded_result = method_with_block { 1 + 2 }
    assert_equal 3, yielded_result
  end

  def test_blocks_can_be_defined_with_do_end_too
    yielded_result = method_with_block do 1 + 2 end
    assert_equal 3, yielded_result
  end

  # ------------------------------------------------------------------

  def method_with_block_arguments
    yield("Jim")
  end

  def test_blocks_can_take_arguments
    method_with_block_arguments do |argument|
      assert_equal "Jim", argument
    end
  end

  # ------------------------------------------------------------------

  def many_yields
    yield(:peanut)
    yield(:butter)
    yield(:and)
    yield(:jelly)
  end

  def test_methods_can_call_yield_many_times
    result = []
    many_yields { |item| result << item }
    assert_equal [:peanut, :butter, :and, :jelly], result
  end

  # ------------------------------------------------------------------

  def yield_tester
    if block_given?
      yield
    else
      :no_block
    end
  end

  def test_methods_can_see_if_they_have_been_called_with_a_block
    assert_equal :with_block, yield_tester { :with_block }
    assert_equal :no_block, yield_tester
  end

  # ------------------------------------------------------------------

  def test_block_can_affect_variables_in_the_code_where_they_are_created
    value = :initial_value
    method_with_block { value = :modified_in_a_block }
    assert_equal :modified_in_a_block, value
  end

  def test_blocks_can_be_assigned_to_variables_and_called_explicitly
    add_one = lambda { |n| n + 1 }
    assert_equal 11, add_one.call(10)

    # Alternative calling syntax
    assert_equal 11, add_one[10]
  end

  def test_stand_alone_blocks_can_be_passed_to_methods_expecting_blocks
    make_upper = lambda { |n| n.upcase }
    result = method_with_block_arguments(&make_upper) #converting explicit block to implicit.
    assert_equal "JIM", result
  end

  # ------------------------------------------------------------------
  # Very good reference about lambdas and Procs in Ruby: http://culttt.com/2015/05/13/what-are-lambdas-in-ruby/

  def method_with_explicit_block(&block) #c onverting implicit block to explicit
    block.call(10)
  end

  def test_methods_can_take_an_explicit_block_argument
    assert_equal 20, method_with_explicit_block { |n| n * 2 }

    add_one = lambda { |n| n + 1 }
    assert_equal 11, method_with_explicit_block(&add_one) # converting explicit block to implicit which then will be converted to explicit again in line 86
  end

  # Good reference for implicit vs explicit blocks in Ruby: https://rubymonk.com/learning/books/4-ruby-primer-ascent/chapters/18-blocks/lessons/55-new-lesson
end
