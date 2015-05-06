require 'terminfo'
require 'pry'

##==============================================

class Console

	def initialize(slide_array)
		@slide_array = slide_array
		@slide_index = 0		
	end

	def start
		@slide_array[@slide_index].printer
	end

	def listen
		print ">"
		action = gets.chomp

		if(action == "next" && (@slide_index < @slide_array.size - 1))

			@slide_index += 1
			@slide_array[@slide_index].printer
			true

		elsif(action == "previous" && (@slide_index >= 1))

			@slide_index -= 1
			@slide_array[@slide_index].printer
			true

		elsif(action == "exit")
			false
		else
			print "Invalid command"
			sleep(1)
			start
		end
	end
end

class OpenFile

	def initialize(file)
		@file = file	
	end

	def open_action
		file_array = IO.read(@file)
	    file_array.split("\n----\n")
	end
end

class Horizontal

	def initialize(sentence, sentence_width)
		@sentence_width = sentence_width
		@sentence = sentence
	end

	def centred
		screen_width = TermInfo.screen_size[1]
		offset_width = (screen_width - @sentence_width)/2
		extra_spaces = " "*offset_width
		extra_spaces + @sentence 
	end
end

class Vertical

	def centred
		screen_height = TermInfo.screen_size[0]
		offset_height = screen_height/2 + 1
	end
end

class Slide

	def initialize(sentence)
		@sentence = sentence	
	end

	def printer
		vertical = Vertical.new
		offset_height = vertical.centred

		(1..offset_height -1).each do 
			puts
		end	

		horizontal = Horizontal.new(@sentence, @sentence.size)
		puts horizontal.centred

		(1..offset_height -1).each do 
			puts
		end	
	end
end

#===============================================================

open = OpenFile.new("presentation.txt")
sentence_array = open.open_action

slide_array = []

sentence_array.each_with_index do |sentence, i| 
			slide_array[i] = Slide.new(sentence)
end

console = Console.new(slide_array)
console.start

working = true

while (working) do
	working = console.listen
end



