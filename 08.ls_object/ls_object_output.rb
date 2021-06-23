# frozen_string_literal: true

module Ls
  class Output < Format
    def default
      file_entries_transpose.size.times do |array_num|
        file_entries_transpose[array_num].each do |file|
          print file_path_format(file)
        end
        print "\n"
      end
    end

    def longformat
      puts "total #{blocks_sum}"
      @file_entries.each do |file|
        print permissions_format(file)
        print links_format(file)
        print users_format(file)
        print groups_format(file)
        print file_sizes_format(file)
        print times_format(file)
        print file_path_format(file)
        print "\n"
      end
    end
  end
end
