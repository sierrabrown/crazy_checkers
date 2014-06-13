require './piece.rb'

class Board
  attr_accessor :grid
  
  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end
  
  def seed
    color = { 0 => "Red", 1 => "Red", 2 => "Red,", 5 => "Black", 6 => "Black", 7 => "Black"}
    
    [0,1,2,5,6,7].each do |row|
      (0..7).each do |col|
        if (row.even? && col.odd?) || (row.odd? && col.even?)
          @grid[row][col] = Piece.new([row,col], color[row], self)
        end
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
        elsif tile.is_a?(Piece)
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
          duped_piece = square.class.new([row_idx, col_idx], square.color, dup_grid, square.king)
          dup_grid.grid[row_idx][col_idx] = duped_piece
        end
      end
    end
    dup_grid
  end
  
  # TA: :white, :black
  def won?(player_color)
    player_color == "Black" ? other_color = "Red" : other_color = "Black"
    @grid.flatten.compact.none? { |piece| piece.color == other_color }
  end
end
