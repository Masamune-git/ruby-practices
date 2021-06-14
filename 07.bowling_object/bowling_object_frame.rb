# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot

  def initialize(first_mark, second_mark)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
  end

  def scores_array
    [first_shot.score,
     second_shot.score]
  end
end
