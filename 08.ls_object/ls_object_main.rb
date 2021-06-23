# frozen_string_literal: true

require_relative 'ls_object_files_formater'
require_relative 'ls_object_file_formater'
require_relative 'ls_object_output'
require 'optparse'
require 'etc'
require 'fileutils'
require 'date'

module Ls
  class Main
    attr_reader :file_entries, :option

    def initialize
      opt = OptionParser.new
      @file_entries = Dir.glob('*').sort
      @option = []
      opt.on('-a') { @option << 'a' }
      opt.on('-r') { @option << 'r' }
      opt.on('-l') { @option << 'l' }
      opt.parse(ARGV)
    end

    def generate
      option_file_entries = option_file_entries(file_entries, option)
      option_output_format(option_file_entries, option)
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

Ls::Main.new.generate
