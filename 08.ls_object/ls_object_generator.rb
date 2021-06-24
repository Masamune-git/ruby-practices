# frozen_string_literal: true

module Ls
  class Generator
    def initialize(file_entries, option)
      @file_entries = file_entries
      @option = option
    end

    def generate
      option_file_entries = option_file_entries(@file_entries, @option)
      formatted_text = option_output_format(option_file_entries, @option)
      Output.new(formatted_text).output
    end

    def option_file_entries(file_entries, option)
      file_entries = Dir.glob('*', File::FNM_DOTMATCH).sort if option[:a]
      file_entries = file_entries.reverse if option[:r]
      file_entries
    end

    def option_output_format(file_entries, option)
      return FilesFormatter.new(file_entries).long_format if option[:l]

      FilesFormatter.new(file_entries).formatted_print
    end
  end
end
