require_relative "board"
require_relative "player"

class Game 
  
  def initialize(max_round = 1, board = Board.new())
    @board = board
    @round = 1
    @turn = true
    @max_round = max_round
    @player1 = Player.new("Player_1", "O")
    @player2 = Player.new("Player_2", "X")
  end

  def play
    until self.game_end?
      @board.print_board()
      puts get_status_str()
      user_input = self.get_user_input_placement()
      curr_player = @turn ? @player1 : @player2
      @board.place_token(user_input, curr_player.token)
      @turn = !@turn
      if @board.game_over?[0]
        @board.print_board()
        update_to_curr_game_res(@board.game_over?)
        reset_new_round()
        @round += 1
      end
    end
    # End game
    print_end_game_status()
  end

  def game_end?
    return @round > @max_round
  end

  def reset_new_round()
    @board = Board.new
    @turn = true
    puts "\n\nnew round..."
  end

  def get_user_input_placement
    regex = /^[1-7]$/
    curr_player = @turn? @player1 : @player2
    puts "#{curr_player.name}'s turn. Token : #{curr_player.token}. Enter column number : (1-7)"
    user_input = gets().chomp!
    until regex.match?(user_input)
      puts "#{curr_player.name}'s turn. Token : #{curr_player.token}. Enter column number : (1-7)"
      user_input = gets().chomp!
    end
    return user_input
  end

  def update_to_curr_game_res(game_res)
    _, token = game_res
    if token == nil
      puts "Round ended with tie."
      return
    end
    winning_player = token == @player1.token ? @player1 : @player2
    winning_player.score += 1
    puts "This round won by #{winning_player.name}"
  end

  def print_end_game_status
    is_tie = @player1.score == @player2.score 
    puts "Game Ended!! | " + get_status_str
    if is_tie
      puts "Nobody has won, its a tie ...."
      return
    end
    winning_player = @player1.score > @player2.score ? @player1 : @player2
    puts "#{winning_player.name} has won!"
  end

  def get_status_str
    "Round : #{@round}/#{@max_round} |  P1: #{@player1.score}  |  P2: #{@player2.score}"
  end

end