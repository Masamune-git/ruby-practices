# !/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

def file_line_count(file)
  File.read(file).count("\n")
end

def file_word_count(file)
  File.read(file).scan(/\s+/).count
end

def file_bite_size(file)
  File.lstat(file).size
end

def total_file_line_count(files)
  files.sum { |file| file_line_count(file) }
end

def total_file_word_count(files)
  files.sum { |file| file_word_count(file) }
end

def total_file_bite_size(files)
  files.sum { |file| file_bite_size(file) }
end

files = ARGV
opt = OptionParser.new
option = []
opt.on('-l') do
  option << 'l'
  files.shift
end
opt.parse(ARGV)

if files.empty? # 標準入力から受け取る場合の処理
  std_input = readlines.join
  printf '% *s', 8, std_input.count("\n")
  unless option.include?('l')
    printf '% *s', 8, std_input.scan(/\s+/).count
    printf '% *s', 8, std_input.size
  end
  print "\n"
end

if option.include?('l') #-lオプションの処理
  files.each do |file|
    printf '% *s', 8, file_line_count(file)
    puts format '% s', " #{file}"
  end
else
  files.each do |file|
    printf '% *s', 8, file_line_count(file)
    printf '% *s', 8, file_word_count(file)
    printf '% *s', 8, file_bite_size(file)
    puts format '% s', " #{file}"
  end
end

# 複数ファイルを読み取った場合の処理
if files.size >= 2 && option.include?('l') #-lオプションの処理
  printf '% *s', 8, total_file_line_count(files)
  puts format '% s', ' total'
elsif files.size >= 2 && option.include?('l') == false
  printf '% *s', 8, total_file_line_count(files)
  printf '% *s', 8, total_file_word_count(files)
  printf '% *s', 8, total_file_bite_size(files)
  puts format '% s', ' total'
end
