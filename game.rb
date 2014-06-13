require './board.rb'

class Game
  
  attr_accessor :gameboard, :current_player
  
  def initialize
    @gameboard = Board.new
    @gameboard.seed
    @player1 = "Red"
    @player2 = "Black"
    @current_player = @player1
  end
  
  def next_turn
    if @current_player == @player1
      @current_player = @player2
    else
      @current_player = @player1
    end
  end
  
  def get_input
    puts "#{current_player} Enter your moves in the following format ( 11 22 33 )"
    
    moves = gets.chomp.split(" ")
    moves_arr = moves.map { |move| move.split("").map { |n| n.to_i} }
    p moves_arr
  end
  
  def player_turn
    @gameboard.display
    
    input = get_input
    x = input[0][0]
    y = input[0][1]
    @gameboard.grid[x][y].perform_moves(input)
  end
  
  def play
    until @gameboard.won?(@current_player)
      begin
        player_turn
      rescue
        puts "That won't work. Try Again."
        retry
      end
      next_turn
    end
    "Congratulations #{@current_player}"
  end
end

g = Game.new
g.play