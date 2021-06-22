# frozen_string_literal: true

module Ls
  class Generate
    def initialize(file_entries, option)
      file_entries = Dir.glob('*', File::FNM_DOTMATCH).sort if option.include?('a')
      file_entries = file_entries.reverse if option.include?('r')
      return list_segments_output_longformat(file_entries) if option.include?('l')

      list_segments_output(file_entries)
    end

    def list_segments_output(file_entries)
      Output.new(file_entries).default
    end

    def list_segments_output_longformat(file_entries)
      Output.new(file_entries).longformat
    end
  end
end
