# frozen_string_literal: true

require_relative 'ls_object_files_formatter'
require_relative 'ls_object_file_formatter'
require_relative 'ls_object_output'
require_relative 'ls_object_generator'
require 'optparse'
require 'etc'
require 'fileutils'
require 'date'

module Ls
  class Input
    def initialize
      opt = OptionParser.new
      @file_entries = Dir.glob('*').sort
      @option = {}
      opt.on('-a') { |v| @option[:a] = v }
      opt.on('-r') { |v| @option[:r] = v }
      opt.on('-l') { |v| @option[:l] = v }
      opt.parse(ARGV)
    end

    def generate
      Generator.new(@file_entries, @option).generate
    end
  end
end

Ls::Input.new.generate
