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
		@board = Board.new(GridSize).spaces
		@players = []
		TotalPlayers.times { @players << Player.new }
		#turns started so far
		@turns = 0
		@won = false
		display
	end

	def turn
		@turns += 1
		puts "Player #{current_player+1}'s turn."
		update(take_coordinates)
		return self
	end

	def update(coordinates)

		row = coordinates[0]
		column = coordinates[1]

		char = @players[current_player].char
		@board[row][column] = char

		if in_a_row(coordinates) == GridSize
			@won = true
		end

	end






	def display
		@board.each_with_index do |row, i| 
			puts row.join('|')
			print "-" * (GridSize * 2 - 1) + "\n" unless i == GridSize - 1
		end
	end

	def over?
		if @won == true
			puts "Congratulations, Player #{current_player+1}!"
			puts "You won!"
			return true
		else
			rows_full_status = @board.map do |row|
				row.none? { |space| space == " " }
			end
			all_full = rows_full_status.all? {|full| full == true }
			if all_full
				puts "It's a draw!"
				return true
			else
				return false
			end
		end
	end

	#private

	def current_player
		(@turns-1) % TotalPlayers
	end

	def take_coordinates
		puts "Enter row from 0 to #{GridSize-1}:"
		row = valid_coordinate
		puts "Enter column from 0 to #{GridSize-1}:"
		column = valid_coordinate
		if @board[row][column] == ' '
			return [row, column]
		else
			puts "Sorry, that space is taken."
			take_coordinates
		end
	end
	def valid_coordinate
		input = gets.chomp
		if input =~ /^+?[0-9]+$/ && input.to_i < GridSize
			return input.to_i
		else
			puts "Sorry, please enter a number from 0 to #{GridSize-1}:"
			valid_coordinate
		end
	end


	def in_a_row(coordinates)
		home_row = coordinates[0]
		home_column = coordinates[1]
		total = 1
		total_one_way = 1

		orientations = [
			{horizontal: 0, vertical: 1}, #up
			{horizontal: 1, vertical: 0}, #right
			{horizontal: 1, vertical: 1}, #up-right
			{horizontal: -1, vertical: 1} #bottom-right
		]
		orientation = 0
		direction = 1

		while total < GridSize && orientation < 4
			row_increment = orientations[orientation][:horizontal] * total_one_way * direction
			column_increment = orientations[orientation][:vertical] * total_one_way * direction
			if (home_row+row_increment).between?(0,GridSize-1) && (home_column+column_increment).between?(0,(GridSize-1))
				current_coordinate = @board[home_row+row_increment][home_column+column_increment]
				#puts "current coordinate : #{home_row+row_increment}, #{home_column+column_increment}"
			else
				current_coordinate = nil
				#puts "current coordinate : nillio"
			end

			if current_coordinate.nil? == false && current_coordinate == @players[current_player].char
				#puts "match!"
				total += 1
				total_one_way += 1
			elsif direction > 0
				#puts "no match--going other way"
				direction = -1
				total_one_way = 1
			else
				#puts "no match--new orientation"
				orientation += 1
				direction = 1
				total_one_way = 1
				total = 1
			end
		end
		return total
	end

end

end

include TicTacToe

game = Game.new
until game.over?
	game.turn.display
end
puts "Game over!"
