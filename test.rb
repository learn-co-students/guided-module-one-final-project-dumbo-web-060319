require 'pry'
require 'daru'

advantage_table = 

{

	"fire":	 %w"0.5	0.5	2	1	2	1	1	1	1	1	0.5	2	1	1	0.5",
    "water":	 %w"2	0.5	0.5	1	1	1	1	1	1	2	2	1	1	1	0.5",
    "grass":	 %w"0.5	2	0.5	1	1	1	1	1	0.5	2	2	0.5	0.5	1	0.5",
    "electric":    	%w"1	2	0.5	0.5	1	1	1	1	2	0	1	1	1	1	0.5",
    "ice":	   %w"1	0.5	2	1	0.5	1	1	1	2	2	1	1	1	1	2",
    "psychic":    	%w"1	1	1	1	1	0.5	1	2	1	1	1	1	2	1	1",
    "normal":	    %w"1	1	1	1	1	1	1	1	1	1	0.5	1	1	0	1",
    "fighting":    	%w"1	1	1	1	2	0.5	2	1	0.5	1	2	0.5	0.5	0	1",
    "flying":	    %w"1	1	2	0.5	1	1	1	2	1	1	0.5	2	1	1	1",
    "ground":	    %w"2	1	0.5	2	1	1	1	1	0	1	2	0.5	2	1	1",
    "rock":	  %w"2	1	1	1	2	1	1	0.5	2	0.5	1	2	1	1	1",
    "bug":	   %w"0.5	1	2	1	1	2	1	0.5	0.5	1	1	1	2	1	1",
    "poison":	    %w"1	1	2	1	1	1	1	1	1	0.5	0.5	2	0.5	0.5	1",
    "ghost":	 %w"1	1	1	1	1	0	0	1	1	1	1	1	1	2	1",
    "dragon":	    %w" 1	 1	 1	 1	 1	 1	 1	 1	 1	 1	 1	 1	 1	 1	 1"

}

advantage_frame = Daru::DataFrame.new(advantage_table, index: advantage_table.keys)
binding.pry

def calculate_advantage

0