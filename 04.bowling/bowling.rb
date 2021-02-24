#!/usr/bin/env ruby

score = ARGV[0]

scores = score.split(',')
shots = []
scores.each do |s|
  if shots.size >= 18
    if s == 'X'
      shots << 10
    else
      shots << s.to_i
    end
  elsif s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end
point = 0

9.times do |i|
  if frames[i][0] == 10 # strike
    if frames[i + 1][0] == 10 && i != 8
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

if frames.size == 10
  point += frames[9].sum
else
  (frames.size - 9).times do |i|
    point += frames[frames.size - 1 - i].sum
  end
end
puts point
