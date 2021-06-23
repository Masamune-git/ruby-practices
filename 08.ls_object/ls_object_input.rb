# frozen_string_literal: true

require_relative 'ls_object_files_formatter'
require_relative 'ls_object_file_formatter'
require_relative 'ls_object_output'
require_relative 'ls_object_generate'
require 'optparse'
require 'etc'
require 'fileutils'
require 'date'

module Ls
  class Input
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
      Generate.new(@file_entries, @option).generate
    end
  end
end

Ls::Input.new.generate
