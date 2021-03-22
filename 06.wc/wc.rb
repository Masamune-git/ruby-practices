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
output_width = 8 # 生成文字列の長さ

if files.empty? # 標準入力から受け取る場合の処理
  std_input = readlines.join
  printf '% *s', output_width, std_input.count("\n")
  unless option.include?('l')
    printf '% *s', output_width, std_input.scan(/\s+/).count
    printf '% *s', output_width, std_input.size
  end
  print "\n"
end

if option.include?('l') #-lオプションの処理
  files.each do |file|
    printf '% *s', output_width, file_line_count(file)
    puts format '% s', " #{file}"
  end
else
  files.each do |file|
    printf '% *s', output_width, file_line_count(file)
    printf '% *s', output_width, file_word_count(file)
    printf '% *s', output_width, file_bite_size(file)
    puts format '% s', " #{file}"
  end
end

# 複数ファイルを読み取った場合の処理
if files.size >= 2
  printf '% *s', output_width, total_file_line_count(files)
  unless option.include?('l') #-lオプションがない場合
    printf '% *s', output_width, total_file_word_count(files)
    printf '% *s', output_width, total_file_bite_size(files)
  end
  puts format '% s', ' total'
end
