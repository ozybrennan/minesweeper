class Board

  attr_accessor :board, :board_size

  def initialize(board_size)
    @board_size = board_size

    @board = Array.new(board_size) { |i| Array.new(board_size){ |j| Tile.new('safe', self, [i, j]) }}
    seed_bombs
  end

  def seed_bombs
    used_positions = []
    until used_positions.length == 10
      position = [rand(8), rand(8)]
      unless used_positions.include?(position)
        used_positions << position
        board[position.first][position.last] = Tile.new("bomb", self, position)
      end
    end

    board
  end

  def all_tiles
    @board.flatten
  end

  def [](pos)
    @board[pos.first][pos.last]
  end

  def reveal_tile(position)
    self[position].reveal
  end

  def prettify_board(position, end_game)
    @board.each do |row|
      temp_row = []
      row.each do |tile|
        temp_row << tile.inspect(position, end_game)
      end

      p temp_row
    end
  end

end
