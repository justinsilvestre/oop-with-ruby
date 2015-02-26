Letters = %w(A B C D E F G)

class Game

	def initialize
		@pattern = 0
		@won = false
		@turn = 0
		@computer_code = Code.new
		@board = Board.new(@computer_code)
		display
	end

	def take_turn
		@turn += 1
		puts "choose a four-letter code with these letters: #{Letters.join}"
		user_code = Code.new(gets.chomp)
		
		@board << user_code

		if user_code == @computer_code
			@won = true
			puts "Congratulations! You won!"
		elsif @turn == 12
			puts "Sorry, you're out of turns!"
			puts "The code was #{@computer_code.to_s}."
		end
			
		
		return self
	end

	def display
		@board.display
	end

	def over?
		if @turn == 12
			return true
		elsif @won == true
			return true
		else
			return false
		end
	end
end

class Board
	def initialize(code_to_guess)
		@code_to_guess = code_to_guess
		@rows = []
	end
	def display 
		@rows.reverse_each.with_index do |row, i|
			puts (@rows.length-i).to_s.rjust(2) + row
		end
	end
	def <<(code_to_add)
		@rows << "| #{code_to_add.to_s} || #{process(code_to_add)}"
	end
	def process(code)
		xs = ""
		os = ""
		code.array.each_with_index do |letter, i|
			if letter == @code_to_guess[i]
				xs += "x"
			elsif @code_to_guess.include? letter
				os += "o"
			end
		end
		return xs + os
	end
end

class Code
	attr_accessor :code
	def initialize(input=random_code)
		validate_code(input)
	end
	def validate_code(input)
		repeats = input.upcase.split(//).uniq.length != input.length
		if input.upcase =~ /^[A-G]+$/ && input.length == 4 && repeats == false
			@code = input.upcase
			return input.upcase
		else
			puts "Sorry, your code must contain no repeat letters or letters past G."
			validate_code(gets.chomp)
		end
	end
	def ==(comparison)
		if comparison.is_a? Code
			if @code == comparison.code
				return true
			else
				return false
			end
		else
			if @code == comparison
				return true
			else
				return false
			end
		end
	end
	def random_code
		output = ""
		letters = %w(A B C D E F G)
		until output.length == 4
			rand_index = rand(letters.length)
			output << letters[rand_index]
			letters.delete(letters[rand_index])	
		end
		return output
	end
	def [](index)
		return @code[index]
	end
	def include?(string)
		@code.include?(string)
	end
	def array
		@code.split(//)
	end
	def to_s
		@code.to_s
	end
end

game = Game.new
until game.over?
	game.take_turn.display
end
puts "Game over!"