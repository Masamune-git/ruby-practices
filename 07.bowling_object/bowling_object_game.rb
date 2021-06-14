# frozen_string_literal: true

class Game
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
      @frames << Frame.new(score[0], score[1])
    end
  end

  def score
    point = 0
    @frames[0].first_shot.score
    @frames[0].score
    9.times do |frame_num|
      point +=
        if @frames[frame_num].first_shot.score == 10 # strike
          if @frames[frame_num + 1].first_shot.score == 10 && frame_num != 8 # 2F連続でstrikeだった場合
            10 + 10 + @frames[frame_num + 2].first_shot.score
          else
            10 + @frames[frame_num + 1].score
          end
        elsif @frames[frame_num].score == 10 # spare
          10 + @frames[frame_num + 1].first_shot.score
        else
          @frames[frame_num].score
        end
    end
    point += @frames[9].score
    point += @frames[10].score if @frames.size == 11
    point
  end
end
