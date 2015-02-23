require_relative "board"
require_relative "tile"
require "io/console"

class Game

  attr_accessor :board

  def initialize(board_size)
    @board_size = board_size
    @board = Board.new(board_size)
    @position = [0,0]
  end

  def run
    until over?
      @board.prettify_board(@position, false)
      move = get_user_input
      perform_move(move)
    end
    puts "You win!"
  end

  def perform_move(move)
    if move == "r"
      @board.reveal_tile(@position)
    elsif move == "f"
      @board[@position].set_flag
    else
      update_position(move)
    end
  end

  def update_position(move)
    dictionary = {"w" => [1, 0], "s" => [-1, 0], "a" => [0, -1], "d" => [0, 1]}
    @position.first += dictionary[move].first
    @position.last += dictionary[move].last
  end

  def get_user_input
    puts "Please move or flag."
    begin
      move = $stdin.getch.downcase
      possible_answers = %w[w a s d r f]
      raise ArgumentError unless possible_answers.include?(move)
    rescue ArgumentError
      puts "Please enter valid input"
      retry
    end
    move
  end

  def over?
    @board.all_tiles.all? { |tile| tile.revealed || tile.state == "bomb"}
  end

end
