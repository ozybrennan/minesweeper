class Tile
  attr_accessor :state, :revealed, :pos, :flag

  def initialize(state, board, pos)
    @state, @board, @pos = state, board, pos
    @revealed, @flag = false, false
  end

  def set_flag
    @flag = !@flag
  end

  def inspect(end_game = false)
    return "flag" if @flag
    return "    " if self.count_bombs == 0 && @state == "safe" && @revealed
    return "_#{self.count_bombs}__" if @revealed
    return @state if @state == "bomb" && end_game
    "____"
  end

  def reveal
    if @flag
      puts "That's flagged!"
    elsif @state == "bomb"
      puts "Game over!"
      @board.end_board
      exit
    else
      expand_neighbors
      @revealed = true
    end
    @state
  end

  def expand_neighbors
    neighbors = find_neighbor

    until neighbors.count == 0
      neighbor = neighbors.shift

      if neighbor.state == "safe" && neighbor.revealed == false
        neighbor.revealed = true

        if neighbor.count_bombs == 0
          neighbor.find_neighbor.each do |next_neighbor|
            neighbors << next_neighbor
          end
        end
      end
    end
  end

  def count_bombs
    bomb_count = 0
    find_neighbor.each do |neighbor|
      if neighbor.state == "bomb"
        bomb_count += 1
      end
    end
    bomb_count
  end

  def find_neighbor
    offsets = [
      [-1, -1], [-1, 0], [-1, 1],
      [0, -1], [0, 1],
      [1, -1], [1, 0], [1, 1]
    ]

    neighbors = []

    x_orig, y_orig = @pos

    offsets.each do |offset|
      neighbors << [x_orig + offset[0], y_orig + offset[1]]
    end

    neighbors.select! { |x, y| (0...@board.board_size).include?(x) && (0...@board.board_size).include?(y) }
    neighbors.map{ |x, y| @board[[x, y]] }
  end

end
