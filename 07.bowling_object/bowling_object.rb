# frozen_string_literal: true

NINTH_FRAME_ENDED = 18
scores = ARGV[0].split(',')

class Game
  attr_reader :frames

  def initialize(scores)
    @frames = []
    scores_array = []
    scores.each do |score|
      if score == 'X' # strikeの処理
        scores_array << 'X'
        scores_array << 0 if scores_array.size < NINTH_FRAME_ENDED # 1~9F目でstrikeの場合2投目を0にする
      else
        scores_array << score.to_i
      end
    end

    scores_array_slice = scores_array.each_slice(2).to_a
    scores_array_slice.each do |frame|
      @frames << Frame.new(frame[0],frame[1],frame[2])
    end
    
  end
  
  def score
    
    frames_score = frames.map{|frame| frame.score}
    
    point = 0
    9.times do |frame_num|
      point +=
        if frames_score[frame_num][0] == 10 # strike
          if frames_score[frame_num + 1][0] == 10 && frame_num != 8 # 2F連続でstrikeだった場合
            10 + 10 + frames_score[frame_num + 2][0]
          else
            10 + frames_score[frame_num + 1].sum
          end
        elsif frames_score[frame_num].sum == 10 # spare
          10 + frames_score[frame_num + 1][0]
        else
          frames_score[frame_num].sum
        end
    end
    point += frames_score[9..10].flatten.sum
  end
end

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark, third_mark)
    if third_mark.nil?
      third_mark = 0
    end

    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score
    [first_shot.score,
     second_shot.score,
     third_shot.score]
  end
end

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def score
    return 10 if mark == 'X'

    mark.to_i
  end
end


game = Game.new(scores)

p game.score
