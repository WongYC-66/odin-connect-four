require_relative "../lib/game"
require_relative "../lib/board"
require_relative "../lib/player"

describe Game do

  let(:board_instance) { instance_double(Board) }

  # game_end?
  describe("#game_end?") do

    subject(:test_game) { described_class.new(10, board_instance) }

    context("when current game round > max_round") do
      it("returns true") do
        test_game.instance_variable_set(:@round, 11)
        expect(test_game.game_end?).to eql(true)
      end
    end

    context("when current game round == max_round") do
      it("returns false") do
        test_game.instance_variable_set(:@round, 10)
        expect(test_game.game_end?).to eql(false)
      end
    end

    context("when current game round < max_round") do
      it("returns false") do
        test_game.instance_variable_set(:@round, 1)
        expect(test_game.game_end?).to eql(false)
      end
    end
  end

  describe("#get_user_input_placement") do

    subject(:test_game) { described_class.new(5, board_instance) }

    before do
      allow(test_game).to receive(:puts)
    end
    
    context("when user enter valid column number") do
      it("returns same char without linebreak") do
        allow(test_game).to receive(:gets).and_return("5\n")
        expect(test_game.get_user_input_placement).to eql("5")
      end
    end

    context("when user enter invalid column number") do
      it("prompts user until getting valid input") do
        allow(test_game).to receive(:gets).and_return("0\n", "8\n", "-1\n", "A\n", "55\n", "5\n",)
        expect(test_game).to receive(:puts).at_least(5).times
        res = test_game.get_user_input_placement()
        expect(res).to eql("5")
      end
    end

  end

  describe("#play") do

    subject(:test_game) { described_class.new(1, board_instance) }
    before do
      allow(test_game).to receive(:print_end_game_status)
      allow(test_game).to receive(:get_user_input_placement)
      allow(test_game).to receive(:puts)
      allow(board_instance).to receive(:print_board)
      allow(board_instance).to receive(:place_token)
    end
    
    context("when game ended") do
      it("triggers print_end_game_status") do
        allow(test_game).to receive(:game_end?).and_return(true)
        expect(test_game).to receive(:print_end_game_status).once
        expect(test_game).to receive(:get_user_input_placement).at_most(0).time
        test_game.play()
      end
    end

    context("when plays normally") do
      it("increases round by 1 and swap the turn") do
        allow(test_game).to receive(:game_end?).and_return(false, false, false, true)
        allow(board_instance).to receive(:game_over?).and_return([false, nil], [false, nil], [true, nil], [false, nil])
        expect(test_game).to receive(:get_user_input_placement).at_most(3).time
        test_game.play()
        expect(test_game.instance_variable_get(:@round)).to eql(2)
        expect(test_game.instance_variable_get(:@turn)).to eql(true)
      end
    end

  end

end

