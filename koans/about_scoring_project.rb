require File.expand_path(File.dirname(__FILE__) + '/neo')

# Greed is a dice game where you roll up to five dice to accumulate
# points.  The following "score" function will be used to calculate the
# score of a single roll of the dice.
#
# A greed roll is scored as follows:
#
# * A set of three ones is 1000 points
#
# * A set of three numbers (other than ones) is worth 100 times the
#   number. (e.g. three fives is 500 points).
#
# * A one (that is not part of a set of three) is worth 100 points.
#
# * A five (that is not part of a set of three) is worth 50 points.
#
# * Everything else is worth 0 points.
#
#
# Examples:
#
# score([1,1,1,5,1]) => 1150 points
# score([2,3,4,6,2]) => 0 points
# score([3,4,5,3,3]) => 350 points
# score([1,5,1,2,4]) => 250 points
#
# More scoring examples are given in the tests below:
#
# Your goal is to write the score method.

def calculate_occurrences(dice_throws)
  dice_throws.each_with_object(Hash.new(0)) { |number, counts| counts[number] += 1 }
end

def occurrences_not_in_a_set_of_three(number_of_occurrences, has_set_of_three)
  has_set_of_three ? (number_of_occurrences - 3).abs : number_of_occurrences
end

def has_set_of_three?(occurrences)
  occurrences >= 3
end

def number_with_sets_of_three_other_than_one(occurrences)
  sets_of_three_other_than_one = occurrences.select { |number, occurrences| number != 1 && occurrences >= 3 }
  sets_of_three_other_than_one.empty? ? 0 : sets_of_three_other_than_one.keys[0]
end

def calculate_score_of_ones(occurrences_of_one)
  has_set_of_three_ones = has_set_of_three?(occurrences_of_one)
  ones_not_part_of_a_set_of_three = occurrences_not_in_a_set_of_three(occurrences_of_one, has_set_of_three_ones)
  (has_set_of_three_ones ? 1000 : 0) + (ones_not_part_of_a_set_of_three * 100)
end

def calculate_score_of_single_fives(occurrences_of_five)
  has_set_of_three_fives = has_set_of_three?(occurrences_of_five)
  fives_not_part_of_a_set_of_three = occurrences_not_in_a_set_of_three(occurrences_of_five, has_set_of_three_fives)
  fives_not_part_of_a_set_of_three * 50
end

def calculate_score_of_sets_other_than_one(occurrences)
  number_with_sets_of_three_other_than_one(occurrences) * 100
end

def score(dice_throws)
  raise ArgumentError, 'Number of dices should not be greater than 5' if dice_throws.size > 5
  return 0 if dice_throws.empty?

  occurrences_per_number = calculate_occurrences(dice_throws)

  calculate_score_of_ones(occurrences_per_number[1]) +
    calculate_score_of_single_fives(occurrences_per_number[5]) +
    calculate_score_of_sets_other_than_one(occurrences_per_number)
end

class AboutScoringProject < Neo::Koan
  def test_score_of_an_empty_list_is_zero
    assert_equal 0, score([])
  end

  def test_score_of_a_single_roll_of_5_is_50
    assert_equal 50, score([5])
  end

  def test_score_of_a_single_roll_of_1_is_100
    assert_equal 100, score([1])
  end

  def test_score_of_multiple_1s_and_5s_is_the_sum_of_individual_scores
    assert_equal 300, score([1, 5, 5, 1])
  end

  def test_score_of_single_2s_3s_4s_and_6s_are_zero
    assert_equal 0, score([2, 3, 4, 6])
  end

  def test_score_of_a_triple_1_is_1000
    assert_equal 1000, score([1, 1, 1])
  end

  def test_score_of_other_triples_is_100x
    assert_equal 200, score([2, 2, 2])
    assert_equal 300, score([3, 3, 3])
    assert_equal 400, score([4, 4, 4])
    assert_equal 500, score([5, 5, 5])
    assert_equal 600, score([6, 6, 6])
  end

  def test_score_of_mixed_is_sum
    assert_equal 250, score([2, 5, 2, 2, 3])
    assert_equal 550, score([5, 5, 5, 5])
    assert_equal 1100, score([1, 1, 1, 1])
    assert_equal 1200, score([1, 1, 1, 1, 1])
    assert_equal 1150, score([1, 1, 1, 5, 1])
  end
end