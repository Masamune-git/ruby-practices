#!/usr/bin/env ruby
require 'optparse'
require "date"

# 変数iが正の場合その数字をカレンダーの日付として出力し、負または最終日よりも大きい数の場合はスペースを出力する
def main(month,year)
  last_day = Date.new(year,month,-1).day
  first_wday = Date.new(year,month,1).wday
  i = 1 - first_wday
  printf("%8s", "#{month}月")
  printf("%5s", "#{year}")
  puts
  puts "日 月 火 水 木 金 土"
  6.times do
    7.times do
      if month == Date.today.month && year == Date.today.year && i == Date.today.day
        printf("%3s", "\e[7;7m#{i}\e[0m ")
      elsif i <= 0 || i > last_day 
        printf("%3s",  "")
      else
        printf("%3s", "#{i} ")
      end
        i += 1
    end
    print "\n"
  end
end

options = ARGV.getopts('m:y:')
month = options["m"].to_i
year = options["y"].to_i
default_month = Date.today.month
default_year = Date.today.year

if 1 <= month && month <= 12 && 1970 <= year && year <=2100
  #変数iはカレンダーの初日(1日)をi=1とした場合に最初の週の日曜日に入る相対的な数である
  main(month,year)  
else
  main(default_month,default_year)
end
