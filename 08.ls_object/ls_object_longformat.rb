# frozen_string_literal: true

module Ls
  class Longformat
    def initialize(file_entries)
      @file_entries = file_entries
      @convert_to_permission = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }
      @convert_to_filetype = { '00' => '-', '40' => 'd', '20' => 'l' }
    end

    def lstat(file)
      File.lstat("./#{file}")
    end

    def blocks_sum
      @file_entries.map { |file| lstat(file).blocks }.sum
    end

    def blocks(file_status)
      file_status.blocks
    end

    def permissions(file_status)
      @convert_to_filetype[file_status.mode.to_s(8)[-5, 2]] +
        @convert_to_permission[file_status.mode.to_s(8)[-3, 1]] +
        @convert_to_permission[file_status.mode.to_s(8)[-2, 1]] +
        @convert_to_permission[file_status.mode.to_s(8)[-1, 1]]
    end

    def links(file_status)
      file_status.nlink.to_s
    end

    def users(file_status)
      Etc.getpwuid(file_status.uid).name.to_s
    end

    def groups(file_status)
      Etc.getgrgid(file_status.gid).name.to_s
    end

    def file_sizes(file_status)
      file_status.size.to_s
    end

    def times(file_status)
      "#{file_status.mtime.strftime('%m').to_i} #{file_status.mtime.strftime('%e')} #{file_status.mtime.strftime('%H:%M')}"
    end

    def paths(file_status)
      file_status
    end

    def links_max_length
      @file_entries.map { |file| links(lstat(file)) }.max_by(&:length).size + 1
    end

    def users_max_length
      @file_entries.map { |file| users(lstat(file)) }.max_by(&:length).size + 1
    end

    def groups_max_length
      @file_entries.map { |file| groups(lstat(file)) }.max_by(&:length).size + 2
    end

    def file_sizes_max_length
      @file_entries.map { |file| file_sizes(lstat(file)) }.max_by(&:length).size + 2
    end

    def output
      # puts "total #{@longformats['blocks'].map.sum}"
      puts "total #{blocks_sum}"
      @file_entries.each do |file|
        file_status = lstat(file)
        printf '% -*s', 11, permissions(file_status).to_s
        printf '% *s', links_max_length, links(file_status).to_s
        printf '% -*s', users_max_length, " #{users(file_status)}"
        printf '% -*s', groups_max_length, "  #{groups(file_status)}"
        printf '% *s', file_sizes_max_length, "  #{file_sizes(file_status)}"
        printf '% *s', 13, "#{times(file_status)} "
        puts format paths(file).to_s
      end
    end
  end
end
