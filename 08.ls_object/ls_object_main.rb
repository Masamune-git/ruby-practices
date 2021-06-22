# frozen_string_literal: true

module Ls
  class Main
    attr_reader :file_entries, :option
    def initialize
      require_relative 'ls_object_list'
      require_relative 'ls_object_format'
      require_relative 'ls_object_output'
      require 'optparse'
      require 'etc'
      require 'fileutils'
      require 'date'
      
      opt = OptionParser.new
      @file_entries = Dir.glob('*').sort
      @option = []
      opt.on('-a') { @option << 'a' }
      opt.on('-r') { @option << 'r' }
      opt.on('-l') { @option << 'l' }
      opt.parse(ARGV)
    end

    def generate      
      Generate.new(file_entries,option)
    end
  end
end

Ls::Main.new.generate
