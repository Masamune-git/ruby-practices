# frozen_string_literal: true

module Ls
  class List
    def initialize(file_entries, option)
      file_entries = Dir.glob('*', File::FNM_DOTMATCH).sort if option.include?('a')
      file_entries = file_entries.reverse if option.include?('r')

      if option.include?('l')
        list_segments_output_longformat(file_entries)
      else
        list_segments_output(file_entries)
      end
    end

    def max_filename_length(file_entries)
      file_entries.max_by(&:length).size + 2
    end

    def list_segments_output(file_entries)
      file_entries << '' while file_entries.size % 3 != 0
      file_entries_transpse = file_entries.each_slice(file_entries.size / 3).to_a.transpose
      file_entries_transpse.size.times do |x|
        file_entries_transpse[x].each  do |file|
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
