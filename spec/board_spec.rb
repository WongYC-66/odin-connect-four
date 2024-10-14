require_relative "../lib/board"

describe Board do
  
  describe("#initialize") do
  # no test needed
end

  describe("#place_token") do
    context("when placing the token normally") do
      subject(:test_board) { described_class.new }
      let(:user_input) {"1"}
      let(:user_token) {"O"}

      it("returns true and modifies the board") do
        res = test_board.place_token(user_input, user_token)

        expect(res).to eql(true)
        expect(test_board.instance_variable_get(:@board)[-1][user_input.to_i - 1]).to eql(user_token) 
      end
    end

    context("when user input a column out of range") do
      subject(:test_board) { described_class.new }
      let(:user_input) {"9"}
      let(:user_token) {"O"}

      it("returns false and does not modify the board") do
        res = test_board.place_token(user_input, user_token)
        expect(res).to eql(false)
        expect(test_board.instance_variable_get(:@board)[-1][user_input.to_i - 1]).to eql(nil) 
      end
    end

    context("when user input a column which is full") do
      subject(:test_board) { described_class.new([
        [" ", " ", "X", " ", " ", " ", " "],
        [" ", " ", "O", " ", " ", " ", " "],
        [" ", " ", "X", " ", " ", " ", " "],
        [" ", " ", "O", " ", " ", " ", " "],
        [" ", " ", "X", " ", " ", " ", " "],
        [" ", " ", "O", " ", " ", " ", " "],
      ])}

      let(:user_input) {"3"}
      let(:user_token) {"O"}

      it("returns false and does not modify the board") do
        res = test_board.place_token(user_input, user_token)
        expect(res).to eql(false)
        expect(test_board.instance_variable_get(:@board)[0][user_input.to_i - 1]).to eql("X") 
      end
    end
  end

  describe("#horizontal_match?") do
    context("when there is horizontal match for 'O'") do
      subject(:test_board) { described_class.new([
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", "O", " ", " ", " ", " "],
        [" ", " ", "X", " ", " ", " ", " "],
        [" ", " ", "X", " ", " ", " ", " "],
        [" ", "O", "X", "X", "O", "X", "X"],
        [" ", "O", "X", "O", "O", "O", "O"],
      ])}

      it("returns [true, 'O']") do
        res = test_board.horizontal_match?
        expect(res).to eql([true, 'O'])
      end
    end
  end

  describe("#vertical_match?") do
    context("when there is vertical match for 'X'") do
      subject(:test_board) { described_class.new([
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", "O", " ", " ", " ", " "],
        [" ", " ", "X", " ", " ", " ", " "],
        [" ", " ", "X", " ", " ", " ", " "],
        [" ", "O", "X", "X", "O", "X", "X"],
        [" ", "O", "X", "O", "O", "O", "O"],
      ])}

      it("returns [true, 'X']") do
        res = test_board.vertical_match?
        expect(res).to eql([true, 'X'])
      end
    end
  end

  describe("#diagonal_match?") do
    context("when there is bottom-left-to-top-right diagonal match for 'O'") do
      subject(:test_board) { described_class.new([
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", "O", " ", " ", " "],
        [" ", " ", "O", "X", " ", " ", " "],
        [" ", "O", "X", "X", " ", " ", " "],
        ["O", "O", "X", "X", "O", " ", " "],
      ])}

      it("returns [true, 'O']") do
        res = test_board.diagonal_match?
        expect(res).to eql([true, 'O'])
      end
    end
    context("when there is top-left-to-bottom-right diagonal match for 'X'") do
      subject(:test_board) { described_class.new([
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", "X", " ", "O", " ", " ", " "],
        [" ", "O", "X", "X", " ", " ", " "],
        [" ", "O", "O", "X", " ", " ", " "],
        [" ", "O", "X", "O", "X", " ", " "],
      ])}

      it("returns [true, 'X']") do
        res = test_board.diagonal_match?
        expect(res).to eql([true, 'X'])
      end
    end
  end

  describe("#game_over?") do
    context("when there is a match") do
      subject(:test_board) { described_class.new([
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", "O", " ", " ", " "],
        [" ", " ", "O", "X", " ", " ", " "],
        [" ", "O", "X", "X", " ", " ", " "],
        ["O", "O", "X", "X", "O", " ", " "],
      ])}

      it("returns [true, 'O']") do
        res = test_board.game_over?
        expect(res).to eql([true, 'O'])
      end
    end

    context("when there is a tie") do
      subject(:test_board) { described_class.new([
        ["X", "O", "X", "O", "X", "O", "X"],
        ["O", "X", "O", "X", "O", "X", "O"],
        ["O", "X", "O", "X", "O", "X", "O"],
        ["X", "O", "X", "O", "X", "O", "X"],
        ["X", "O", "X", "O", "X", "O", "X"],
        ["O", "X", "O", "X", "O", "X", "O"],
      ])}

      it("returns [true, nil]") do
        res = test_board.game_over?
        expect(res).to eql([true, nil])
      end
    end

    context("when no match, no tie") do
      subject(:test_board) { described_class.new([
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "],
        ["X", " ", " ", " ", " ", " ", " "],
        ["X", "O", " ", " ", " ", " ", " "],
        ["O", "X", "O", " ", " ", " ", " "],
      ])}

      it("returns [false, nil]") do
        res = test_board.game_over?
        expect(res).to eql([false, nil])
      end
    end
  end
end
