# frozen_string_literal: true

# !/usr/bin/env ruby

scores = ARGV[0].split(',')

# 数字に変換
shots = []
NINTH_FRAME_ENDED = 18
scores.each do |score|
  if score == 'X' # strikeの処理
    shots << 10
    shots << 0 if shots.size < NINTH_FRAME_ENDED # 1~9F目でstrikeの場合2投目を0にする
  else
    shots << score.to_i
  end
end

# 2投ごとに1Fとして分割
frames = shots.each_slice(2).to_a

# 点数計算
point = 0
9.times do |frame_no|
  point +=
    if frames[frame_no][0] == 10 # strike
      if frames[frame_no + 1][0] == 10 && frame_no != 8 # 2F連続でstrikeだった場合
        10 + 10 + frames[frame_no + 2][0]
      else
        10 + frames[frame_no + 1].sum
      end
    elsif frames[frame_no].sum == 10 # spare
      10 + frames[frame_no + 1][0]
    else
      frames[frame_no].sum
    end
end

# 10F目は合計を足すだけ
point += frames[9..10].flatten.sum

puts point
