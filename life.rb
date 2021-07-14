
class Cell
  attr_reader :alive

  class << self
    def dead_cell
      Cell.new(:dead)
    end

    def live_cell
      Cell.new(:alive)
    end
  end

  def initialize(state)
    @state = state
    @living_neighbors = 0
  end

  def dead?
    @state == :dead
  end

  def alive?
    @state == :alive
  end

  def notify
    @next = nil
    @living_neighbors += 1
  end

  def living_neighbors
    @living_neighbors
  end

  def next
    @next ||= if alive? && (living_neighbors == 2 || living_neighbors == 3)
      Cell.live_cell
    elsif dead? && living_neighbors == 3
      Cell.live_cell
    else
      Cell.dead_cell
    end
  end
end

class Board
  attr_reader :grid

  def initialize(rows, cols)
    @grid = rows.times.map {
      cols.times.map {
        rand(100).odd? ? Cell.dead_cell : Cell.live_cell
      }
    }
  end

  def tick
    @grid.each.with_index{|row,row_idx|
      row.each.with_index{|cell,col_idx|
        notify_neighbors(row_idx, col_idx) if cell.alive?
      }
    }

    @grid = @grid.map{|row|
      puts
      row.map{|cell|
        printf("%d,%d=%d ", cell.alive? && 1 || 0, cell.living_neighbors, cell.next.alive? && 1 || 0)
        cell.next
      }
    }
  end

  def notify_neighbors(row, col)
    [*[0,row-1].max..[row+1,@grid.length - 1].min].each { |row_idx|
      [*[0,col-1].max..[col+1,@grid[row_idx].length - 1].min].each { |col_idx|
        next if [row_idx, col_idx] == [row, col]
        @grid[row_idx][col_idx].notify
      }
    }
  end

  def display
    @grid.each{|row|
      row.each{|cell|
        print cell.alive? ? "1" : "-"
      }
      puts
    }
  end

  def extinct?
    @grid.flatten.all?{|cell| cell.dead? }
  end
end

def main
  board = Board.new(10, 10)
  while true
    puts
    board.display
    board.tick

    break if board.extinct?

    sleep(0.4)
  end
end

main

