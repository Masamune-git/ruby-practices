# frozen_string_literal: true

module Ls
  class Output < Format
    def default
      file_entries_transpose.size.times do |array_num|
        file_entries_transpose[array_num].each do |file|
          file_status = Filedata.new(file)
          print default_path_format(file_status)
        end
        print "\n"
      end
    end

    def longformat
      puts "total #{blocks_sum}"
      @file_entries.each do |file|
        file_status = Filedata.new(file)
        print permissions_format(file_status)
        print links_format(file_status)
        print users_format(file_status)
        print groups_format(file_status)
        print file_sizes_format(file_status)
        print times_format(file_status)
        puts format file_status.paths.to_s
      end
    end
  end
end
