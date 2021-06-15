# frozen_string_literal: true

require_relative 'bowling_object_shot'
require_relative 'bowling_object_frame'
require_relative 'bowling_object_game'

scores = ARGV[0].split(',')
game = Game.new(scores)

puts game.score
