# frozen_string_literal: true

module Ls
  class Format
    COLUMNVAL = 3

    def initialize(file_entries)
      @file_entries = file_entries
      @permission_map = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }
      @filetype_map = { '00' => '-', '40' => 'd', '20' => 'l' }
    end

    def lstat(file)
      Filedata.new(file)
    end

    def blocks_sum
      @file_entries.map { |file| Filedata.new(file).blocks }.sum
    end

    def links_max_length
      @file_entries.map { |file| Filedata.new(file).link }.max_by(&:length).size + 1
    end

    def users_max_length
      @file_entries.map { |file| Filedata.new(file).user }.max_by(&:length).size
    end

    def groups_max_length
      @file_entries.map { |file| Filedata.new(file).group }.max_by(&:length).size
    end

    def file_sizes_max_length
      @file_entries.map { |file| Filedata.new(file).file_size }.max_by(&:length).size + 2
    end

    def max_filename_length
      @file_entries.max_by(&:length).size + 1
    end

    def file_times_max_length
      @file_entries.map { |file| Filedata.new(file).time }.max_by(&:length).size
    end

    def file_entries_transpose
      @file_entries << '' while @file_entries.size % COLUMNVAL != 0
      @file_entries.each_slice(@file_entries.size / COLUMNVAL).to_a.transpose
    end

    def file_path_format(file_status)
      file_status.path.to_s.ljust(max_filename_length)
    end

    def permissions_format(file_status)
      file_status.permission.to_s.ljust(11)
    end

    def links_format(file_status)
      file_status.link.to_s.rjust(links_max_length)
    end

    def users_format(file_status)
      " #{file_status.user.ljust(users_max_length)}"
    end

    def groups_format(file_status)
      "  #{file_status.group.ljust(groups_max_length)}"
    end

    def file_sizes_format(file_status)
      file_status.file_size.rjust(file_sizes_max_length).to_s
    end

    def times_format(file_status)
      "  #{file_status.time.rjust(file_times_max_length)} "
    end
  end
end
