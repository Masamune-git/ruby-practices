# frozen_string_literal: true

module Ls
  class Generator

    def initialize(file_entries, option)
      @file_entries = file_entries
      @option = option
    end

    def generate
      option_file_entries = option_file_entries(@file_entries, @option)
      option_output_format(option_file_entries, @option)
    end

    def option_file_entries(file_entries, option)
      file_entries = Dir.glob('*', File::FNM_DOTMATCH).sort if option.include?('a')
      file_entries = file_entries.reverse if option.include?('r')
      file_entries
    end

    def option_output_format(file_entries, option)
      return FilesFormatter.new(file_entries).longformat if option.include?('l')

      FilesFormatter.new(file_entries).default
    end
  end
end
