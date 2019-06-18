require 'tty-prompt'
require 'pry'

class CommandLineInterface
	attr_accessor :user

	def initialize
		prompt = TTY::Prompt.new
		user_input = prompt.ask('What is your name?')
		@user = User.find_by(name: user_input)
		
		if not @user
			puts "No record found for user #{user_input}. Creating..."
			@user = User.new_user(user_input)
		end

		puts "Welcome, #{user_input}!"
		puts view_record
	end

	def main_menu
		prompt = TTY::Prompt.new
		user_selection = 0
		while user_selection != 99
			user_selection = prompt.select('Please make a selection.') do |menu|
				menu.choice 'View Team', 1
				menu.choice 'View Collection', 2
				menu.choice 'View Record', 3
				menu.choice 'Edit Team', 4
				menu.choice 'Quit', 99
			end

			if user_selection == 1
				view_team
			elsif user_selection == 2
				view_collection
			elsif user_selection == 3
				puts view_record
			elsif user_selection == 4
				edit_team
			end
		end
	end

	def view_team
		puts "Your current team is:"
		@user.team.each {|pokeball| puts pokeball.pokemon.name}
	end

	def view_collection
		puts "You have #{user.pokeballs.length} Pokemon in your collection, including:"
		@user.pokeballs.each {|p| puts p.pokemon.name}
	end

	def edit_team
		#
	end

	def view_record
		"You have #{@user.wins} wins and #{@user.losses} losses."
	end
end