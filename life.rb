require 'minitest/autorun'

def main
  board = Board.from_width_and_height(10, 10)
  while true
    board.cells = board.tick
    puts board.display
  end
end

class Board
  attr_accessor :cells, :width, :height

  class << self
    def from_width_and_height(width, height)
      width, height = width, height
      cells = (width * height).times.map{|i|
        [0,1].sample == 0 ? Cell.dead_cell : Cell.live_cell
      }
      new(width, height, cells)
    end
  end

  def initialize(width, height, initial_state)
    @width, @height, @cells = width, height, initial_state
  end

  def tick
    puts
    display
    @cells.map.with_index do |cell, index|
      process_rules(index)
    end
  end

  def display
    puts @cells.map{|cell| cell.alive? && "1" || "-" }.join
  end

  def process_rules(index) # return Cell.dead_cell or Cell.live_cell
    living = alive_neighbors(index)

    if @cells[index].alive? && [2,3].include?(living)
      Cell.live_cell
    elsif @cells[index].dead? && living == 3
      Cell.dead_cell
    else
      Cell.dead_cell
    end
  end

  def alive_neighbors(index)
    row = (index / @width).floor
    col = index % @width
    alive_neighbors = 0

    indexes = [
      index - 1,
      index + 1,
      index - @width - 1,
      index - @width,
      index - @width + 1,
      index + @width - 1,
      index + @width,
      index + @width + 1,
    ]

    indexes.inject(0){|sum,idx|
      n_row = (idx / @width).floor
      n_col = idx % @width
      next sum if (row-1...row+1).include?(n_row) && (col-1...col+1).include?(n_col)
      if idx >= 0 && idx < @width * @height
        @cells[idx].alive? ? sum + 1 : sum
      else
        sum
      end
    }
  end
end

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
  end

  def dead?
    @state == :dead
  end

  def alive?
    @state == :alive
  end
end

# describe "game of life" do
#   describe "a cell" do
#     it "dies if not enough cells are alive"
#   end
# end

main
