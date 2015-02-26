module TicTacToe

	GridSize = 3 	
	TotalPlayers = 2


class Board
	attr_accessor :side, :spaces
	def initialize(side)
		@side = side
		@spaces = []
		@side.times do
			spaces << Array.new(side, ' ')
		end
	end
	def display
		@spaces.each_with_index do |row, i| 
			display_row = row.join(' | ')
			puts display_row
			print "-" * (display_row.length) + "\n" unless i == side - 1
		end
	end
	def full?
		rows_full_status = @spaces.map{ |row| row.none? { |space| space == " " } }
		rows_full_status.all? {|full| full == true }
	end
	def [](row)
		@spaces[row]
	end
end

class Player
	@@TotalPlayers = 0
	attr_accessor :name, :char
	def initialize
		case @@TotalPlayers
			when 0
				@char = 'X'
			when 1
				@char = 'O'
		end
		@@TotalPlayers += 1
	end
end

class Game

	def initialize
		@board = Board.new(GridSize)
		@players = []
		TotalPlayers.times { @players << Player.new }
		#turns started so far
		@turns = 0
		@won = false
		display
	end

	def turn
		@turns += 1
		puts "Player #{whose_turn+1}'s turn."
		coordinates = take_coordinates
		update(coordinates[0], coordinates[1])
		return self
	end

	def update(row, column)
		@board[row-1][column-1] = @players[whose_turn].char
		@won = true if in_a_row(row, column) == GridSize
	end

	def display
		@board.display
		self
	end

	def over?
		if @won == true
			puts "Congratulations, Player #{whose_turn+1}!"
			puts "You won!"
			return true
		elsif @board.full?
			puts "It's a draw!"
			return true
		else
			return false
		end
	end

	private

	def whose_turn
		(@turns-1) % TotalPlayers
	end

	def take_coordinates
		row = nil
		column = nil
		until row
			puts "Enter row from 1 to #{GridSize}:"
			row = valid_coordinate(gets.chomp)
		end
		until column
			puts "Enter column from 1 to #{GridSize}:"
			column = valid_coordinate(gets.chomp)
		end
		if @board[row-1][column-1] == ' '
			return [row, column]
		else
			puts "Sorry, that space is taken."
			take_coordinates
		end
	end

	def valid_coordinate(input)
		if input.to_s =~ /^+?[0-9]+$/ && input.to_i.between?(1,GridSize)
			return input.to_i
		else
			return false
		end
	end

	Orientations = [
				{horizontal: 0, vertical: 1}, #up
				{horizontal: 1, vertical: 0}, #right
				{horizontal: 1, vertical: 1}, #up-right
				{horizontal: -1, vertical: 1} #down-right
			]

	def in_a_row(home_row, home_column)
		output = 1
		total = 1
		total_from_home = 1
		direction = 1
		Orientations.each do |orientation|
			break if total == GridSize
			step = total_from_home * direction
			row = home_row + (orientation[:horizontal] * step)
			column = home_column + (orientation[:vertical] * step)
			if valid_coordinate(row) && valid_coordinate(column) && @board[row-1][column-1] == @players[whose_turn].char
				total_from_home += 1
				total += 1;
				output = total > output ? total : output
				redo
			else
				direction *= -1
				total_from_home = 1
				redo if direction > 0
				total = 1
			end
		end
		output
	end

end

end

include TicTacToe

game = Game.new
until game.over?
	game.turn.display
end
puts "Game over!"
