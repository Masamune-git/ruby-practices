# frozen_string_literal: true

module Ls
  class Output
    def initialize(output_format)
      @output_format = output_format
    end

    def output
      puts @output_format
    end
  end
end
