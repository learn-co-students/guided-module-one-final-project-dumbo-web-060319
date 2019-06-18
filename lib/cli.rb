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
				menu.choice 'Catch Pokemon', 5
				menu.choice 'Battle', 6
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
			elsif user_selection == 5
				puts catch_pokemon
			elsif user_selection == 6
				battle_menu
			end
		end
		
	end

	def catch_pokemon
		@user.catch
	end

	def battle_menu
		opponent = User.all[rand(0..User.all.length)]
		Battle.do_battle(@user, opponent)
	end

	def view_team
		puts "Your current team is:"
		@user.team.each {|pokeball| puts pokeball.pokemon.name}
	end

	def view_collection
		user_collection = @user.view_pokemons_in_collection
		puts "You have #{user_collection.length} Pokemon in your collection:"
		puts user_collection
	end

	def edit_team
		prompt = TTY::Prompt.new
		if @user.team.count == 6
			user_selection = prompt.select("Your team is full. Remove a Pokemon from your team?") do |menu|
				menu.choice 'Yes', 0
				menu.choice 'No', 1
			end
			if user_selection == 0
				remove_pokemon_from_team
			end
		else
			add_pokemon_to_team
		end
	end

	def remove_pokemon_from_team
		# Remove pokemon from team
	end

	def add_pokemon_to_team
		# Add pokemon to team
	end

	def view_record
		"You have #{@user.wins} wins and #{@user.losses} losses."
	end
end