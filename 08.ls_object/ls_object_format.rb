# frozen_string_literal: true

module Ls
  class FileData
    COLUMNVAL = 3
    def initialize(file_entries)
      @file_entries = file_entries
      @permission_map = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }
      @filetype_map = { '00' => '-', '40' => 'd', '20' => 'l' }
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
      permission_num = file_status.mode.to_s(8)
      @filetype_map[permission_num[-5, 2]] +
        @permission_map[permission_num[-3, 1]] +
        @permission_map[permission_num[-2, 1]] +
        @permission_map[permission_num[-1, 1]]
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

    def max_filename_length
      @file_entries.max_by(&:length).size + 2
    end

    def file_entries_transpose
      @file_entries << '' while @file_entries.size % COLUMNVAL != 0
      @file_entries.each_slice(@file_entries.size / COLUMNVAL).to_a.transpose
    end
  end
end
