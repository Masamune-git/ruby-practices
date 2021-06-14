# frozen_string_literal: true

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

    scores_array_slice = scores_array.each_slice(2)
    scores_array_slice.each do |score|
      @frames << Frame.new(score[0], score[1], score[2])
    end
  end

  def score
    frames_score = frames.map(&:scores_array)
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
