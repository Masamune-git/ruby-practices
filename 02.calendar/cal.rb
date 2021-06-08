#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'date'
options = ARGV.getopts('m:y:')

def main(month, year)
  last_day = Date.new(year, month, -1).day
  first_wday = Date.new(year, month, 1).wday
  # 変数calendar_date_numが正の場合その数字をカレンダーの日付として出力し、負または最終日よりも大きい数の場合はスペースを出力する
  calendar_date_num = 1 - first_wday
  printf('%8s', "#{month}月")
  printf('%5s', year.to_s)
  print "\n"
  puts '日 月 火 水 木 金 土'
  6.times do
    7.times do
      if month == Date.today.month && year == Date.today.year && calendar_date_num == Date.today.day
        printf('%3s', "\e[7;7m#{calendar_date_num}\e[0m ")
      elsif calendar_date_num <= 0 || calendar_date_num > last_day
        printf('%3s', '')
      else
        printf('%3s', "#{calendar_date_num} ")
      end
      calendar_date_num += 1
    end
    print "\n"
  end
end

month = options['m'].to_i
year = options['y'].to_i
default_month = Date.today.month
default_year = Date.today.year

if (1..12).cover?(month) && (1970..2100).cover?(year)
  main(month, year)
else
  main(default_month, default_year)
end
