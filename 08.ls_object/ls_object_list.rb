# frozen_string_literal: true

module Ls
  class List
    COLUMNVAL = 3
    def initialize(file_entries, option)
      file_entries = Dir.glob('*', File::FNM_DOTMATCH).sort if option.include?('a')
      file_entries = file_entries.reverse if option.include?('r')
      return list_segments_output_longformat(file_entries) if option.include?('l')        

      list_segments_output(file_entries)
    end

    def max_filename_length(file_entries)
      file_entries.max_by(&:length).size + 2
    end

    def file_entries_transpse(file_entries)
      file_entries << '' while file_entries.size % COLUMNVAL != 0
      file_entries.each_slice(file_entries.size / COLUMNVAL).to_a.transpose
    end

    def list_segments_output(file_entries)
      file_entries_transpse(file_entries).size.times do |array_num|
        file_entries_transpse(file_entries)[array_num].each  do |file|
          printf '% -*s', max_filename_length(file_entries), file.to_s
        end
        print "\n"
      end
    end

    def list_segments_output_longformat(file_entries)
      Longformat.new(file_entries).output
    end
  end
end
