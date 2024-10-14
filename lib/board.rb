class Board 
  
  def initialize(board = Array.new(6){ Array.new(7, " ")})
    @board = board
  end

  def game_over?
    [horizontal_match?, vertical_match?, diagonal_match?, tie_match?].reduce([false, nil]) do |res, match_res|
      new_res = [
        res[0] || match_res[0],
        res[1] || match_res[1]
      ]
      new_res
    end
  end

  def place_token(user_input, token)
    
    regex = /^[1-7]$/
    return false if !regex.match?(user_input) # invalid input

    user_input = user_input.to_i - 1

    @board.reverse().each_with_index do |row|
      row.each_with_index do |cell, c|
        if c == user_input && cell == " "   # place to most bottom row of selected column
          row[c] = token  # place 
          return true
        end
      end
    end

    return false
  end

  def horizontal_match?
    tokens = ['O', 'X']
    return pattern_match(@board, tokens)
  end

  def vertical_match?
    col_arr = Array.new(7) {Array.new}
    @board.each do |row|
      row.each_with_index do |cell, c|
        col_arr[c].push(cell)
      end
    end

    tokens = ['O', 'X']
    return pattern_match(col_arr, tokens)
  end

  def diagonal_match?
    bot_left_diag = Hash.new {|hash, key| hash[key] = [] }  # r + c
    bot_right_diag = Hash.new {|hash, key| hash[key] = [] }  # r - c
    @board.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        bot_left_diag[r + c].push(cell)
        bot_right_diag[r - c].push(cell)
      end
    end

    tokens = ['O', 'X']
    left_diag_res = pattern_match(bot_left_diag.values, tokens)
    right_diag_res = pattern_match(bot_right_diag.values, tokens)
    return left_diag_res if left_diag_res != [false, nil]
    return right_diag_res if right_diag_res != [false, nil]
    return [false, nil]
  end
  
  def tie_match?
    # only tie when full AND no hori/verti/diag match
    is_full = @board.flatten().count(" ") == 0
    return [false, nil] if !is_full 
    return [false, nil] if [horizontal_match?, vertical_match?, diagonal_match?].any? { |check_res, _| check_res == true}
    return [true, nil]
  end

  def pattern_match(two_d_array, tokens)
    two_d_array.each do |arr|
      arr_joined_string = arr.join('')
      tokens.each do |token|
        return [true, token] if arr_joined_string.include?(token * 4)
      end
    end
    return [false, nil]
  end

end