require './piece.rb'

class Board
  attr_accessor :grid
  
  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end
  
  def seed
    
    color = { 0 => "Red", 1 => "Red", 6 => "Black", 7 => "Black"}
    
    [0,1,6,7].each do |row|
      (0..7).each do |col|
        @grid[row][col] = Piece.new([row,col], color[row], self)
      end
    end
  end
    
  
  def display
    puts "    " + (0..7).to_a.join("  ")
    @grid.each_with_index do |row, index|
      print index.to_s + "  "
      row.each do |tile|
        if tile == nil
          print " _ "
        elsif tile.is_a? Piece
          print " " + tile.symbol + " "
        end
      end
      puts
    end
  end
  
  def deep_dup
    dup_grid = Board.new
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |square, col_idx|
        unless square.nil? 
          duped_piece = square.class.new([row_idx, col_idx], square.color, dup_grid)
          dup_grid.grid[row_idx][col_idx] = duped_piece
        end
      end
    end
    dup_grid
  end
  
  
end

b = Board.new
b.seed
b.grid[0][1].move!([5,4])
b.grid[0][3].move!([3,4])
b.display
b.grid[6][3].perform_moves!([[4,5],[2,3]])
#b.grid[6][3].perform_jump([4,5])

b.display