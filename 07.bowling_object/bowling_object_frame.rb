# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot

  def initialize(first_mark, second_mark)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
  end

  def score
    @first_shot.score + @second_shot.score
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    @first_shot.score + @second_shot.score == 10
  end
end
