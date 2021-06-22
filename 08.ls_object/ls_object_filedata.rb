# frozen_string_literal: true

module Ls
  class Filedata
    # attr_reader : file_status
    def initialize(file)
      @file = file
      @file_status = File.lstat("./#{file}")
      @permission_map = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }
      @filetype_map = { '00' => '-', '40' => 'd', '20' => 'l' }
    end

    def blocks
      @file_status.blocks
    end

    def permissions
      permission_num = @file_status.mode.to_s(8)
      @filetype_map[permission_num[-5, 2]] +
        @permission_map[permission_num[-3, 1]] +
        @permission_map[permission_num[-2, 1]] +
        @permission_map[permission_num[-1, 1]]
    end

    def links
      @file_status.nlink.to_s
    end

    def users
      Etc.getpwuid(@file_status.uid).name.to_s
    end

    def groups
      Etc.getgrgid(@file_status.gid).name.to_s
    end

    def file_sizes
      @file_status.size.to_s
    end

    def times
      "#{@file_status.mtime.strftime('%-m')} #{@file_status.mtime.strftime('%e')} #{@file_status.mtime.strftime('%H:%M')}"
    end

    def paths
      @file
    end
  end
end
