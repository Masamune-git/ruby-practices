# frozen_string_literal: true

# !/usr/bin/env ruby
require 'etc'
require 'fileutils'
require 'optparse'
require 'date'

def list_segments_output(line_value, file_entries)
  max_filename_length = file_entries.max_by(&:length).size + 2
  line_value.times do |x|
    printf '% -*s', max_filename_length, (file_entries[x]).to_s
    printf '% -*s', max_filename_length, (file_entries[x + line_value]).to_s
    puts format '% -*s', max_filename_length, (file_entries[x + line_value * 2]).to_s
  end
end

def list_segments_output_exception(file_entries)
  max_filename_length = file_entries.max_by(&:length).size + 2
  printf '% -*s', max_filename_length, (file_entries[0]).to_s
  printf '% -*s', max_filename_length, (file_entries[2]).to_s
  puts format '% -*s', max_filename_length, (file_entries[3]).to_s
  puts format '% -*s', max_filename_length, (file_entries[1]).to_s
end

def list_segments_output_longformat(file_entries)
  blocks, permissions, links, users, groups, file_sizes, times, paths = Array.new(8).map { [] }
  change1 = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }
  change2 = { '00' => '-', '40' => 'd', '20' => 'l' }
  file_entries.each do |x|
    fs = File.lstat("./#{x}")
    blocks << fs.blocks
    permissions << change2[fs.mode.to_s(8)[-5, 2]] + change1[fs.mode.to_s(8)[-3, 1]] + change1[fs.mode.to_s(8)[-2, 1]] + change1[fs.mode.to_s(8)[-1, 1]]
    links << fs.nlink.to_s
    users << Etc.getpwuid(fs.uid).name.to_s
    groups << Etc.getgrgid(fs.gid).name.to_s
    file_sizes << fs.size.to_s
    times << "#{fs.mtime.strftime('%m').to_i} #{fs.mtime.strftime('%d')} #{fs.mtime.strftime('%H:%M')}"
    paths << x
  end
  puts "total #{blocks.map.sum}"
  longformats = { 'permissions' => permissions, 'links' => links, 'users' => users, 'groups' => groups, 'file_sizes' => file_sizes, 'times' => times,
                  'paths' => paths }
  output(longformats)
end

def output(longformats)
  longformats['permissions'].size.times do |i|
    printf '% -*s', 11, (longformats['permissions'][i]).to_s
    printf '% *s', longformats['links'].max_by(&:length).size + 1, (longformats['links'][i]).to_s
    printf '% -*s', longformats['users'].max_by(&:length).size + 1, " #{longformats['users'][i]}"
    printf '% -*s', longformats['groups'].max_by(&:length).size + 2, "  #{longformats['groups'][i]}"
    printf '% *s', longformats['file_sizes'].max_by(&:length).size + 2, "  #{longformats['file_sizes'][i]}"
    printf '%*s', 13, "#{longformats['times'][i]} "
    puts format (longformats['paths'][i]).to_s
  end
end

opt = OptionParser.new
file_entries = Dir.glob('*').sort
option = []
opt.on('-a') { option << 'a' }
opt.on('-r') { option << 'r' }
opt.on('-l') { option << 'l' }
opt.parse(ARGV)

file_entries = Dir.glob('*', File::FNM_DOTMATCH).sort if option.include?('a')
file_entries = file_entries.reverse if option.include?('r')

if option.include?('l')
  list_segments_output_longformat(file_entries)
  exit!
end

if file_entries.size == 4
  list_segments_output_exception(file_entries)
elsif (file_entries.size % 3).zero?
  list_segments_output(file_entries.size / 3, file_entries)
else
  list_segments_output(file_entries.size / 3 + 1, file_entries)
end
