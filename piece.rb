require 'debugger'

class Piece
  attr_accessor :pos, :color, :symbol, :king
  
  # TA: :up, :down
  DIRS = { "Up" => [[-1, 1],[-1, -1]], "Down" => [[1, -1],[1,1]] }
  
  def initialize(pos, color, board, king = false)
    @pos = pos
    @color = color
    @symbol = color[0]
    @king = king
    @board = board
  end
  
  def piece_dirs
    piece_dirs = []
    if !@king
      if color == "Black"
        piece_dirs = DIRS["Up"]
      else
        piece_dirs = DIRS["Down"]
      end
    elsif @king == true
      piece_dirs = DIRS["Up"] + DIRS["Down"]
    end
    piece_dirs
  end
  
  def legal_moves
    possible_moves = []
    possible_moves << (legal_sliding(piece_dirs) + legal_jumping(piece_dirs))  
  end
  
  def legal_sliding(piece_dirs)
    cur_x = pos[0]
    cur_y = pos[1]
    
    possible_moves = []
    piece_dirs.each do |dir|
      first_x = cur_x + dir[0]
      first_y = cur_y + dir[1]
      
      if on_board?([first_x, first_y])
        # TA: Board#empty?
        possible_moves << [first_x, first_y] if @board.grid[first_x][first_y] == nil
      end
    end
    possible_moves
  end
  
  def legal_jumping(piece_dirs)
    possible_moves = []
    piece_dirs.each do |dir|
      first_x = pos[0] + dir[0]
      first_y = pos[1] + dir[1]
      
      second_x = first_x + dir[0]
      second_y = first_y + dir[1]
      
      if on_board?([second_x, second_y])
        if opponent_here?([first_x, first_y]) && @board.grid[second_x][second_y] == nil
          possible_moves << [second_x, second_y] 
        end
      end
    end
    possible_moves
  end
  
  def opponent_here?(new_pos)
    @board.grid[new_pos[0]][new_pos[1]] != nil && @board.grid[new_pos[0]][new_pos[1]].color != @color
  end
  
  def on_board?(new_pos)
    (0..7).include?(new_pos[0]) && (0..7).include?(new_pos[1])
  end

  def perform_slide(new_pos)
    if legal_sliding(piece_dirs).include?(new_pos) 
      move!(new_pos)
    else
      raise "Invalid move error."
    end
  end
  
  def perform_jump(new_pos)
    if legal_jumping(piece_dirs).include?(new_pos)
      victim_x = (new_pos[0] + pos[0]) / 2
      victim_y = (new_pos[1] + pos[1]) / 2
      
      @board.grid[victim_x][victim_y] = nil
      
      move!(new_pos)
    else
      raise "Invalid move error."
    end
  end
  
  def move!(new_pos)
    x = pos[0]
    y = pos[1]
    
    new_x = new_pos[0]
    new_y = new_pos[1]
    @board.grid[x][y], @board.grid[new_x][new_y] = nil, @board.grid[x][y]
    @board.grid[new_x][new_y].pos = [new_x,new_y]
  end
  
  def promote?(new_pos)
    if new_pos[0] == 0 || new_pos[0] == 7
      king = true
    end
  end
  
  def perform_moves!(move_arr)
    jump = true
    if move_arr.count == 2
      if legal_sliding(piece_dirs).include?(move_arr[1])
        perform_slide(move_arr[1])
        jump = false
      end
    end
    if jump == true
      move_arr[1..-1].each do |move|
        perform_jump(move)
      end
    end
  end
  
  def perform_moves(move_arr)
    if valid_move_sequence?(move_arr)
      perform_moves!(move_arr) 
    else
      raise "Invalid move error."
    end
  end
  
  def valid_move_sequence?(move_arr)
    new_grid = @board.deep_dup
    begin
     new_grid.grid[pos[0]][pos[1]].perform_moves!(move_arr)
    rescue
     return false
    else
     return true
    end
  end
end
