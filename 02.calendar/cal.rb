#!/usr/bin/env ruby
require 'optparse'
require "date"
#オプション用変数
options = ARGV.getopts('m:y:')
get_m = options["m"].to_i
get_y = options["y"].to_i
#デフォルト変数
default_m = Date.today.month
default_y = Date.today.year

def main(m,y,i,last_day)
  printf("%8s", "#{m}月")
  printf("%5s", "#{y}")
  puts
  puts "日 月 火 水 木 金 土"
  6.times do
    7.times do
      if m == Date.today.month && y == Date.today.year && i == Date.today.day
        printf("%3s", "\e[7;7m#{i}\e[0m ")
      elsif i <= 0 || i > last_day 
        printf("%3s",  "")
      else
        printf("%3s", "#{i} ")
      end
        i += 1
    end
    puts 
  end
end

def judge_week(x)
  if x == "Sun"
    1
  elsif x == "Mon"
    0
  elsif x == "Tue"
    -1
  elsif x == "Wed"
    -2
  elsif x == "Thu"
    -3
  elsif x == "Fri"
    -4
  elsif x == "Sat"
    -5
  end
end

if 0 < get_m && get_m < 13 && 1970 <= get_y && get_y <=2100
  last_day = Date.new(get_y,get_m,-1).day
  first_day = Date.new(get_y,get_m,1).strftime('%a')
  i = judge_week(first_day)
  main(get_m,get_y,i,last_day)  
else
  last_day = Date.new(default_y,default_m,-1).day
  first_day = Date.new(default_y,default_m,1).strftime('%a')
  i = judge_week(first_day)
  main(default_m,default_y,i,last_day)
end
