#!/usr/bin/env ruby

score = ARGV[0]

scores = score.split(',')
shots = []

# 数字に変換
scores.each do |s|
  if shots.size >= 18 # 10F目に三回投げていた場合strikeは10のまま
    if s == 'X'
      shots << 10
    else
      shots << s.to_i
    end
  elsif s == 'X' # strikeの場合２投目を0にする
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

# ２投ごとに1Fとして分割
frames = []
shots.each_slice(2) do |s|
  frames << s
end
point = 0

# 点数計算
9.times do |i|
  if frames[i][0] == 10 # strike
    if frames[i + 1][0] == 10 && i != 8 # 2F連続でstrikeだった場合
      point += 10 + 10 + frames[i + 2][0]
    else
      point += 10 + frames[i + 1][0] + frames[i + 1][1]
    end
  elsif frames[i].sum == 10 # spare
    point += 10 + frames[i + 1][0]
  else
    point += frames[i].sum
  end
end

# 10F目は合計を足すだけ
if frames.size == 10
  point += frames[9].sum
else # 10F目に三回投げていた場合
  point += frames[9].sum + frames[10].sum
end
puts point
