# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark, third_mark)
    third_mark = 0 if third_mark.nil?

    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def scores_array
    [first_shot.score,
     second_shot.score,
     third_shot.score]
  end
end
