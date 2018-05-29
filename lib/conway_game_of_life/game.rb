module ConwayGameOfLife
  class Game
    HALF_A_SECOND = 0.5

    attr_reader :board

    def initialize(columns = Board::DEFAULT_COLUMNS,
                   rows = Board::DEFAULT_ROWS,
                   random = true)
      @board = Board.new(columns, rows, random)
    end

    def seed(input)
      board.seed(input)
    end

    def render
      puts board.render + "\n\n"
    end

    def run
      loop do
        render
        sleep(HALF_A_SECOND)
        $stdout.flush
        update
      end
    end

    def update
      next_board = Board.new(board.columns, board.rows, false)
      board.cells.each do |col_index, row|
        row.each do |row_index, _cell|
          update_cell(next_board, col_index, row_index)
        end
      end
      @board = next_board
    end

    def update_cell(next_board, col_i, row_i)
      num_alive = board.neighbours(col_i, row_i).count
      cell = board[row_i, col_i]

      if (num_alive == 3 && cell.dead?) then next_board[row_i, col_i].alive!
      elsif (cell.alive?)
        case num_alive
        when 0..1 then next_board[row_i, col_i].dead!
        when 2..3 then next_board[row_i, col_i].alive!
        when 4..8 then next_board[row_i, col_i].dead!
        end
      end
    end
  end
end
