require_relative "./lib/game"

puts "#################################"
puts "Welcome to the Connect-Four Game"
user_input_round = nil
until user_input_round.to_i >= 1
  puts "Please enter number of game u wish to play : "
  user_input_round = gets().chomp!.to_i
end

new_game = Game.new(user_input_round)
new_game.play()