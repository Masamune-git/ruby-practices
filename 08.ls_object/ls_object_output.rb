# frozen_string_literal: true

module Ls
  class Output < FileData
    def default
      file_entries_transpose.size.times do |array_num|
        file_entries_transpose[array_num].each do |file|
          printf '% -*s', max_filename_length, file.to_s
        end
        print "\n"
      end
    end

    def longformat
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
