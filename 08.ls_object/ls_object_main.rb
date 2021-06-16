# frozen_string_literal: true
require 'optparse'

module Ls
  class Main
    def initialize
      opt = OptionParser.new
      file_entries = Dir.glob('*').sort
      option = []
      opt.on('-a') { option << 'a' }
      opt.on('-r') { option << 'r' }
      opt.on('-l') { option << 'l' }
      opt.parse(ARGV)
      p option
    end
  end
end

Ls::Main.new
