require 'tty-prompt'
require 'pry'
require 'colorize'

class CommandLineInterface
	attr_accessor :user

	$prompt = TTY::Prompt.new 

	# binding.pry

	def initialize
		prompt = TTY::Prompt.new
		user_input = prompt.ask('What is your name?')
		@user = User.find_by(name: user_input)
		
		if not @user
			puts "No record found for user #{user_input}. Creating..."
			@user = User.new_user(user_input)
		end

		puts "Welcome, #{@user.name}!"
		view_record
	end

	def main_menu
		prompt = TTY::Prompt.new
		user_selection = 0

		while user_selection != 99
			user_selection = prompt.select('Please make a selection.') do |menu|
				menu.choice 'Catch Pokemon', 5
				menu.choice 'Battle', 10
				menu.choice 'Pokedex', 7
				menu.choice 'View Collection', 2
				menu.choice 'View Team', 1
				menu.choice 'Edit Team', 4
				menu.choice 'Auto Battle', 6
				menu.choice 'View Record', 3
				menu.choice 'test battle', 8
				menu.choice 'super test battle', 99
				menu.choice 'Quit', -> { exit }
			end
			case user_selection
			when 1
				view_team
			when 2
				view_collection
			when 3
				puts view_record
			when 4
				edit_team
			when 5
				puts catch_pokemon
			when 6
				battle_menu
			when 7
				pokedex
			when 8
				test_battle
			when 99
				super_test_battle
			when 10
				new_battle_menu
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
		# binding.pry
		# menu_option = 0
		# while menu_option != 99
			user_selection = $prompt.select("Your current team is:") do |menu|
				user.team.each do |pokeball|
					menu.choice "#{pokeball.pokemon.name}", -> {pokeball.view_stats_page(pokeball)}			
				end
				menu.choice "Back", -> {main_menu}
			end
		# end 
		# puts "Your current team is:"
		# @user.team.each {|pokeball| puts pokeball.pokemon.name}
	end

	def view_collection
		user_collection = @user.view_pokemons_in_collection
		puts "You have #{user_collection.length} Pokemon in your collection:"
		puts user.view_pokemons_in_collection
	end

	def pokedex
		user_selection = $prompt.select("Pokedex: #{@user.pokedex.count} caught.") do |menu|
			user.pokedex.each do |pokeball|
				menu.choice "#{pokeball.pokemon.name}", -> {pokeball.view_stats_page(pokeball)}			
			end
			# binding.pry
		end
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
			edit_team_menu
		end
	end

	def edit_team_menu
		menu_option = 0
		while menu_option != 99
			menu_option = $prompt.select("Please choose an option:") do |menu|
			menu.choice 'Add', 1
			menu.choice 'Remove', 2
			menu.choice 'Exit Menu', -> {main_menu}
				case menu_option 
				when 1
					if @user.team.count < 6 && @user.not_on_team != []
						add_pokemon_to_team
					elsif @user.team.count == 6
						puts "Your team is full!"
					else 
						puts "No Pokemon to add!"
					end
				when 2
					if @user.team.count == 0
						puts "You have no pokemon on your team!"
					else 
						remove_pokemon_from_team
					end 
				end 
			end
		end 
	end 

	def remove_pokemon_from_team
		user_selection = $prompt.select("Select the pokemon you want to remove.") do |menu|
			user.team.each do |pokeball|
				menu.choice "#{pokeball.pokemon.name}", -> {user.remove_pokeball_from_team(pokeball)} 
			end
			menu.choice "Cancel", -> {edit_team_menu}
		end
	end

	def add_pokemon_to_team
		user_selection = $prompt.select("Select the pokemon you want to add.") do |menu|
			user.not_on_team.sort_by { 
				|pokeball| pokeball.pokemon.name 
			}.uniq { 
				|pokeball| pokeball.pokemon.id
			}.each do |pokeball|
				menu.choice "#{pokeball.pokemon.name}", -> {user.add_pokeball_to_team(pokeball)} 
			end
			menu.choice "Cancel", -> {edit_team_menu}
		end
	end

	def view_record
		puts "You have #{@user.battle_wins.count.to_s.colorize :yellow} #{"wins".colorize :yellow} and #{@user.battle_losses.count.to_s.colorize :red} #{"losses".colorize :red}."
		# puts "#{@user.wins}W #{@user.losses}L"
	end

	def new_battle_menu
		opponent = User.all.sample(1).first
		# opponent = User.all[rand(0..User.all.length)]
		# binding.pry
		prompt = TTY::Prompt.new
		test_battle = Battle.new(user_id: @user.id, opponent_id: opponent.id, user: @user, opponent: opponent)
		test_battle.start_battle 

		battle_main_loop(test_battle)
		
	end

	def battle_main_loop(battle)
		user_selection = 0
		while user_selection != 99
			# test_battle.battle_screen
			user_selection = $prompt.select('Battle') do |menu|
				menu.choice 'Attack', 1
				menu.choice 'Switch', 2
				menu.choice 'Exit', -> { main_menu }
			end
			case user_selection
			when 1 
				# binding.pry
				battle.speed_check
				new_turn_cycle(battle, 'attack')
			when 2
				new_turn_cycle(battle, 'switch')
			end
		end
	end 

	def new_turn_cycle(battle, option)
		case option 
		when 'attack'
			# battle.speed_check
			attack(battle)
			# battle.change_turn
			if !!battle.battle_state[:turn]
				battle.change_turn
				attack(battle)
				battle.clear_turn
				# binding.pry
			else 
				# binding.pry
				# battle.attack
				battle.clear_turn
			end 
		when 'switch'
			switch_pokemon(battle)
			battle.battle_state[:turn] = battle.currentOpponentPokemon 
			attack(battle)
			battle.clear_turn
		end
	end 

	def attack(battle)
		# battle.speed_check
		battle.attack
		sleep 1
		# battle.battle_screen
		if battle.currentUserPokemon[:hp] <= 0
			puts "#{user.name}'s #{battle.currentUserPokemon[:pokemon].name} has fainted!"
			battle.currentUserPokemon[:alive] = false
			# switch_pokemon(battle)
			# battle.clear_turn
			if battle.user_defeat
				puts "returning to main menu"
				main_menu
			else
				switch_pokemon(battle)
				battle.clear_turn
			end 
		elsif battle.currentOpponentPokemon[:hp] <= 0
			# binding.pry
			puts "#{battle.opponent.name}'s #{battle.currentOpponentPokemon[:pokemon].name} has fainted!"
			battle.currentOpponentPokemon[:alive] = false
			
			if battle.opponent_defeat
				puts "returning to main menu"
				main_menu
			else
				battle.switch_opponent_pokemon
				battle.clear_turn
			end 
		end 
	end

	# def new_attack(battle)
	# 	battle.speed_check
	# 	battle.attack
	# 	sleep 1
	# 	# battle.battle_screen
	# 	if battle.currentUserPokemon[:hp] <= 0
	# 		puts "#{user.name}'s #{battle.currentUserPokemon[:pokemon].name} has fainted!"
	# 		battle.currentUserPokemon[:alive] = false
	# 		if battle.user_defeat
	# 			puts "returning to main menu"
	# 			main_menu 
	# 		else 
	# 			switch_pokemon(battle) 
	# 		end
	# 	elsif battle.currentOpponentPokemon[:hp] <= 0
	# 		# binding.pry
	# 		puts "#{battle.opponent.name}'s #{battle.currentOpponentPokemon[:pokemon].name} has fainted!"
	# 		battle.currentOpponentPokemon[:alive] = false
			
	# 		if battle.opponent_defeat
	# 			puts "returning to main menu"
	# 			main_menu
	# 		else
	# 			battle.switch_opponent_pokemon 
	# 			# battle.attack
	# 		end 
	# 	end 
	# end 

	def switch_pokemon(battle)
		prompt = TTY::Prompt.new
		puts "Switch Pokemon!"
		switch_selection = 0
		until switch_selection != 0
			switch_selection = $prompt.select('Switch') do |menu|
				# binding.pry
				alive_team = battle.battle_state[:user][:currentTeam].select { |pokeball| pokeball[:alive] == true }
				alive_team.each do |pokeball|
					# binding.pry
					if pokeball != battle.currentUserPokemon
						menu.choice "#{pokeball[:pokemon][:name]}...... TYPE: #{pokeball[:pokemon][:element_type]}...|...HP: #{pokeball[:hp]}", -> {
							puts "#{user.name} sends out #{pokeball[:pokemon][:name]}!"
							puts "#{pokeball[:pokemon].ascii_color} #{pokeball[:pokemon][:name]}  HP: #{pokeball[:hp]}"
							battle.currentUserPokemon = pokeball
							sleep 1
							battle.battle_state[:turn] = battle.currentOpponentPokemon
							# binding.pry
						}
					end
				end
				menu.choice "Cancel", -> { 
				if battle.currentUserPokemon[:alive] 
					battle_main_loop(battle) 
				else 
					puts "You must switch pokemon!" 
					switch_pokemon(battle)
				end 
			}
			end
		end
	end

	def test_battle
		opponent = User.all.find_by(name: "test battle")
		# opponent = User.all[rand(0..User.all.length)]
		# binding.pry
		prompt = TTY::Prompt.new
		test_battle = Battle.new(user_id: @user.id, opponent_id: opponent.id, user: @user, opponent: opponent)
		test_battle.start_battle 

		battle_main_loop(test_battle)
		
	end

	def super_test_battle
		opponent = User.all.find_by(name: "super test battle")
		# opponent = User.all[rand(0..User.all.length)]
		# binding.pry
		prompt = TTY::Prompt.new
		test_battle = Battle.new(user_id: @user.id, opponent_id: opponent.id, user: @user, opponent: opponent)
		test_battle.start_battle 

		battle_main_loop(test_battle)
		
	end

end
