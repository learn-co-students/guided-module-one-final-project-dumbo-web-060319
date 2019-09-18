class Battle < ActiveRecord::Base
	has_many :users
	has_many :pokeballs, through: :users

	# attr_reader :user, :opponent
	attr_accessor :user, :opponent, 
	:user_team, :opponent_team, 
	:user_pokeball, :opponent_pokeball, 
	:currentUserPokemon, :currentOpponentPokemon,
	:battle_state


	def start_battle
		user = @user
		opponent = @opponent
		# binding.pry
		self.set_initial_battle_state
		user_team = @battle_state[:user][:currentTeam]
		opponent_team = @battle_state[:opponent][:currentTeam]
		@currentUserPokemon = @battle_state[:user][:currentTeam][0]
		@currentOpponentPokemon = @battle_state[:opponent][:currentTeam][0]
		# @currentUserPokemon = user_team[0]
		# @currentOpponentPokemon = opponent_team[0]

		# self.battle_state[:userPokemon][:currentPokemon] = self.battle_state[:userPokemon][:currentTeam][0]
		# self.battle_state[:opponentPokemon][:currentPokemon] = self.battle_state[:opponentPokemon][:currentTeam][0]

		puts "#{user.name.upcase} vs #{opponent.name.upcase}!!!"
		# binding.pry
		puts "#{user.name} sends out #{@currentUserPokemon[:pokemon].name}!!"
		# sleep 1
		puts "#{@currentUserPokemon[:pokemon].ascii_color}"
		puts "#{@currentUserPokemon[:pokemon].name}  HP:#{@currentUserPokemon[:hp]}"
		sleep 1
		# binding.pry
		puts "#{opponent.name} sends out #{@currentOpponentPokemon[:pokemon].name}!!"
		puts "#{@currentOpponentPokemon[:pokemon].name}  HP:#{@currentOpponentPokemon[:hp]}"
		puts "#{@currentOpponentPokemon[:pokemon].ascii_color}"
	end 

	def battle_screen
		# binding.pry
		user = @user
		# opponent = @opponent
			# currentUserPokemon = self.battle_state[:userPokemon][:currentPokemon]
			# currentOpponentPokemon = self.battle_state[:opponentPokemon][:currentPokemon]
		# currentUserPokemon = @currentUserPokemon
		# currentOpponentPokemon = @currentOpponentPokemon
		# user_team = @battle_state[:user][:currentTeam]
		# opponent_team = @battle_state[:opponent][:currentTeam]
	
		# binding.pry
		puts "#{user.name} vs #{opponent.name}"
		puts "#{@currentUserPokemon[:pokemon].ascii_color}"
		puts "    #{@currentUserPokemon[:pokemon].name}  HP:#{@currentUserPokemon[:hp]}"
		puts "VS  #{@currentOpponentPokemon[:pokemon].name}  HP:#{@currentOpponentPokemon[:hp]}"
		puts "#{@currentOpponentPokemon[:pokemon].ascii_color}"
	
	end 

	def attack
		user = @user
		opponent = @opponent
		currentUserPokemon = @currentUserPokemon
		currentOpponentPokemon = @currentOpponentPokemon

		case self.battle_state[:turn]
		when currentUserPokemon
			defender = currentOpponentPokemon
			#check damage
			damage = Battle.damage_calc(currentUserPokemon[:pokemon], currentOpponentPokemon[:pokemon])
			#user attacks opponent
			puts currentUserPokemon[:pokemon].ascii_color
			puts "#{currentUserPokemon[:pokemon].name} attacks #{currentOpponentPokemon[:pokemon].name}!"
			sleep 1
			currentOpponentPokemon[:hp] -= damage
			type_advantage = Battle.type_advantage(currentUserPokemon[:pokemon], currentOpponentPokemon[:pokemon])
			puts "#{defender[:pokemon].ascii_color}"
			puts "#{defender[:pokemon].name}  HP:#{defender[:hp].clamp(0, defender[:pokemon].hp)}"
				case type_advantage
				when 0
					puts "#{currentOpponentPokemon[:pokemon].name} is immune to #{currentUserPokemon[:pokemon].element_type} attacks!"
				when 0.5
					puts "#{currentUserPokemon[:pokemon].name} hit #{currentOpponentPokemon[:pokemon].name} for #{damage} damage...".colorize :blue
					puts "It's not very effective..".colorize :blue
				when 1.0
					puts "#{currentUserPokemon[:pokemon].name} hit #{currentOpponentPokemon[:pokemon].name} for #{damage} damage!"
				when 2.0
					puts "#{currentUserPokemon[:pokemon].name} hit #{currentOpponentPokemon[:pokemon].name} for #{damage} damage!!".colorize :green
					puts "It's super effective!!!".colorize :green
				end 
			# binding.pry
			#show portrait 
			# puts "#{defender[:pokemon].ascii_color}"
			# puts "#{defender[:pokemon].name}  HP:#{defender[:hp].clamp(0, defender[:pokemon].hp)}"
			#switch turn
			# self.battle_state[:turn] = currentOpponentPokemon
		when currentOpponentPokemon  
			defender = currentUserPokemon
			#check damage
			damage = Battle.damage_calc(currentOpponentPokemon[:pokemon], currentUserPokemon[:pokemon])
			#opponent attacks user
			puts currentOpponentPokemon[:pokemon].ascii_color
			puts "#{currentOpponentPokemon[:pokemon].name} attacks #{currentUserPokemon[:pokemon].name}!"
			sleep 1
			currentUserPokemon[:hp] -= damage
			# binding.pry
			type_advantage = Battle.type_advantage(currentOpponentPokemon[:pokemon], currentUserPokemon[:pokemon])
			#show portait here, ACTUALLY 
			puts "#{defender[:pokemon].ascii_color}"
			puts "#{defender[:pokemon].name}  HP:#{defender[:hp].clamp(0, defender[:pokemon].hp)}"
				case type_advantage
				when 0
					puts "#{currentUserPokemon[:pokemon].name} is immune to #{currentOpponentPokemon[:pokemon].element_type} attacks!"
				when 0.5
					puts "#{currentOpponentPokemon[:pokemon].name} hit #{currentUserPokemon[:pokemon].name} for #{damage} damage...".colorize :blue
					puts "It's not very effective..".colorize :blue
				when 1.0
					puts "#{currentOpponentPokemon[:pokemon].name} hit #{currentUserPokemon[:pokemon].name} for #{damage} damage!"
				when 2.0
					puts "#{currentOpponentPokemon[:pokemon].name} hit #{currentUserPokemon[:pokemon].name} for #{damage} damage!!".colorize :green
					puts "It's super effective!!!".colorize :green
				end 
			#show portrait 
			
			# #switch turn
			# self.battle_state[:turn] = currentUserPokemon
		end

	end

	def deal_damage

	end

	def speed_check 
		puts "speed check"
		# binding.pry
		# self.currentUserPokemon[:pokemon].speed > self.currentOpponentPokemon[:pokemon].speed ? self.currentUserPokemon : self.currentOpponentPokemon
		# binding.pry
		if self.currentUserPokemon[:pokemon].speed > self.currentOpponentPokemon[:pokemon].speed
			self.battle_state[:turn] = self.currentUserPokemon
			# binding.pry
		else 
			self.battle_state[:turn] = self.currentOpponentPokemon
		end 
		# binding.pry
	end 

	def change_turn 
		case self.battle_state[:turn]
		when currentUserPokemon
			self.battle_state[:turn] = currentOpponentPokemon
		when currentOpponentPokemon 
			self.battle_state[:turn] = currentUserPokemon 
		end 
	end 

	def clear_turn 
		self.battle_state[:turn] = nil
	end 

	def switch_opponent_pokemon
		if self.currentOpponentPokemon[:alive] == false 
			alive_team = self.battle_state[:opponent][:currentTeam].select { |pokeball| pokeball[:alive] == true }
				# alive_team.each do |pokeball|
				# 	# binding.pry
				# 	if pokeball != self.currentOpponentPokemon
				# 		binding.pry
				# 	end
				# end
			# binding.pry
			if alive_team != []
			self.currentOpponentPokemon = alive_team[0]
			# self.switch_prompt(currentOpponentPokemon)
			# self.sendOutOpponentPokemon
			puts "#{currentOpponentPokemon[:pokemon].ascii_color}   HP:#{@currentOpponentPokemon[:hp]}"
			puts "#{opponent.name} sent out #{currentOpponentPokemon[:pokemon][:name]}!"
			elsif alive_team == []
				# binding.pry
				self.opponent_defeat
			end 
		end 
	end 

	def switch_prompt(next_pokemon)

	end 

	def opponent_defeat 
		# binding.pry
		if self.battle_state[:opponent][:currentTeam].select { |pokeball| pokeball[:alive] == true }.length == 0
			save_battle_results(user, opponent)
			puts "YOU WIN!!"
			puts "#{user.name} defeated #{opponent.name}!!"
			puts "#{user.name}: #{user.battle_wins.count} #{user.battle_wins.count == 1 ? "Win" : "Wins"}!!".colorize :yellow
			puts "#{opponent.name}: #{opponent.battle_losses.count} #{opponent.battle_losses.count == 1 ? "Loss" : "Losses"}...".colorize :red
			return true
		else
			return false
		end 
		# return true
	end

	def user_defeat 
		# binding.pry
		if self.battle_state[:user][:currentTeam].select { |pokeball| pokeball[:alive] == true }.length == 0
			save_battle_results(opponent, user)
			puts "YOU LOST!!"
			puts "#{opponent.name} defeated #{user.name}!!"
			puts "#{user.name}: #{user.battle_losses.count} #{user.battle_losses.count == 1 ? "Loss" : "Losses"}...".colorize :red
			puts "#{opponent.name}: #{opponent.battle_wins.count} #{opponent.battle_wins.count == 1 ? "Win" : "Wins"}!!".colorize :yellow
			return true
		else
			return false
		end 
		# return true
	end

	def save_battle_results(winner, loser)
		winner.wins += 1
		loser.losses += 1
		winner.save
		loser.save
		# binding.pry
		self.winner = winner.id
		self.save(user_id: @user.id, opponent_id: @opponent.id, winner: winner.id)
	end 

	def self.do_battle(user, opponent)
		@user = user
		@opponent = opponent
		@user_team = @user.team
		@opponent_team = @opponent.team
		
		until @user_team.length == 0 or @opponent_team.length == 0 do
			@user_pokeball = @user_team[0]
			@opponent_pokeball = @opponent_team[0]
			winner = self.fight(@user_pokeball, @opponent_pokeball)
			self.remove_defeated_pokemon(winner)
		end

		puts "\n"
		if @user_team.length > 0
			puts "#{@user.name} defeated #{@opponent.name}!"
			record_results(@user, @opponent)
		elsif @opponent_team.length > 0
			puts "#{@opponent.name} defeated #{@user.name}!"
			record_results(@opponent, @user)
		end
	end

	def self.record_results(battle_winner, battle_loser)
		battle_winner.wins += 1
		battle_loser.losses += 1
		battle_winner.save
		battle_loser.save
		Battle.create(user_id: @user.id, opponent_id: @opponent.id, winner: battle_winner.id)
	end

	def self.fight(user_pokeball, opponent_pokeball)
		user_pokeball.hp = user_pokeball.pokemon.hp
		opponent_pokeball.hp = opponent_pokeball.pokemon.hp
		puts "\n\n"
		sleep 1
		puts "#{@user.name} sent out #{user_pokeball.pokemon.name}!"
		puts "#{user_pokeball.pokemon.ascii_color}"
		sleep 1
		puts "#{@opponent.name} sent out #{opponent_pokeball.pokemon.name}!"
		puts "#{opponent_pokeball.pokemon.ascii_color}"
		sleep 1
		puts
		puts "\n"
		sleep 1
		attack_order = order_roll
		until user_pokeball.hp <= 0 or opponent_pokeball.hp <=0 do
			attacker = attack_order[0]
			defender = attack_order[1]
			puts "#{attacker.pokemon.name} attacked!"
			attack_roll = self.attack_accuracy
			if attack_roll == "miss"
				puts "#{attacker.pokemon.name} missed!"
			elsif attack_roll == "hit"
				damage = self.damage_calc(user_pokeball.pokemon, opponent_pokeball.pokemon)
				type_advantage = self.type_advantage(attacker.pokemon, defender.pokemon)
				case type_advantage
				when 0
					puts "#{defender.pokemon.name} is immune to #{attacker.pokemon.element_type} attacks!"
				when 0.5
					puts "#{attacker.pokemon.name} hit #{defender.pokemon.name} for #{damage} damage...".colorize :blue
					puts "It's not very effective..".colorize :blue
				when 1.0
					puts "#{attacker.pokemon.name} hit #{defender.pokemon.name} for #{damage} damage!"
				when 2.0
					puts "#{attacker.pokemon.name} hit #{defender.pokemon.name} for #{damage} damage!!".colorize :green
					puts "It's super effective!!!".colorize :green
				end 
				defender.hp -= damage
			elsif attack_roll == "critical"
				critical_hit = self.damage_critical(user_pokeball.pokemon, opponent_pokeball.pokemon)
				if type_advantage == 2.0
					puts "#{attacker.pokemon.name} hit #{defender.pokemon.name} for #{damage} damage!!!".colorize :light_red
					puts "Critical hit!! And it's Super Effective!!!!".colorize :light_red
				else 
					puts "#{attacker.pokemon.name} hit #{defender.pokemon.name} for #{damage} damage!!!".colorize :yellow
					puts "Critical hit!!".colorize :yellow
				end
				defender.hp -= critical_hit
			end
			attack_order = attack_order.reverse
			sleep 0.5
		end
		puts "#{defender.pokemon.name} was defeated!"
		attacker
	end

	def self.remove_defeated_pokemon(winner)
		if @user_team.include?(winner)
			@opponent_team.shift
		elsif @opponent_team.include?(winner)	
			@user_team.shift
		end
	end

	def self.order_roll
		if @user_pokeball.pokemon.speed > @opponent_pokeball.pokemon.speed
			[@user_pokeball, @opponent_pokeball]
		else 
			[@opponent_pokeball, @user_pokeball]
		end 

		# roll = rand(0 .. 100)
		# if roll > 50
		# 	[@user_pokeball, @opponent_pokeball]
		# else
		# 	[@opponent_pokeball, @user_pokeball]
		# end
	end

	#Damage = ((((2 * Level / 5 + 2) * AttackStat * AttackPower / DefenseStat) / 50) + 2) 
	#		  		* STAB * Weakness/Resistance * RandomNumber / 100

	#Actually it's ((2A/5+2)*B*C)/D)/50)+2)*X)*Y/10)*Z)/255
	#  ((((2 * 50)/5)+2) * attacker.attack * 60)/defender.defense)/50)+2)*(type_modifier/10)*(rando_between_217_and_255))/255
	# A = attacker's Level
	# B = attacker's Attack or Special
	# C = attack Power
	# D = defender's Defense or Special
	# X = same-Type attack bonus (1 or 1.5)
	# Y = Type modifiers (40, 20, 10, 5, 2.5, or 0) // 4, 2, 1, .5, .25, 0 // with dual types considered
	# 20, 10, 5, 0 // 2, 1, .5, 0 // single type// Super, Normal, Not very, Immune
	# Z = a random number between 217 and 255


	#modified damage calculation 
	#Damage = ((Attack / Defense) / 50) * Weakness * RandomNumber / 100 )
	def self.damage_calc(attacker, defender)
		(((((((((2 * 50)/5)+2) * attacker.attack * 65)/defender.defense)/50)+2)*(self.type_advantage(attacker, defender))*(Battle.rando255))/255).round
	end

	def self.damage_critical(attacker, defender)
		(((((((((2 * (50 * 2))/5)+2) * attacker.attack * 65)/defender.defense)/50)+2)*(self.type_advantage(attacker, defender))*(Battle.rando255))/255).round
	end

	def self.attack_accuracy
		roll = rand(0 .. 100)
		if roll < 25
			"miss"
		elsif roll > 80
			"critical"
		else
			"hit"
		end
	end

	def self.rando255
		rand(217..255)
	end

	def self.crit_rando
		rand(0..255)
	end 

	def self.rando100
		(rand(1..100).to_f / 100)
	end 

	def self.critical_hit?(attacker)

	end

	def self.advantage_frame(attacker_type, defender_type)
		attacker_type = attacker_type.to_sym
		defender_type = defender_type.to_sym

		advantage_table = {

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
		"dragon":	    %w" 1	 1	 1	 1	 1	 1	 1	 1	 1	 1	 1	 1	 1	 1	 2"}

		advantage_frame = Daru::DataFrame.new(advantage_table, index: advantage_table.keys)
		binding.pry
		advantage_frame[attacker_type][defender_type].to_f
	end


	##########################################################################

	def self.type_advantage(attacker, defender)
		Battle.dataframe[attacker.element_type.to_sym][defender.element_type.to_sym].to_f
	end 

	def self.dataframe   
	advantage_table = {

		"Fire":	 %w"0.5	0.5	2	1	2	1	1	1	1	1	0.5	2	1	1	0.5",
		"Water":	 %w"2	0.5	0.5	1	1	1	1	1	1	2	2	1	1	1	0.5",
		"Grass":	 %w"0.5	2	0.5	1	1	1	1	1	0.5	2	2	0.5	0.5	1	0.5",
		"Electric":    	%w"1	2	0.5	0.5	1	1	1	1	2	0	1	1	1	1	0.5",
		"Ice":	   %w"1	0.5	2	1	0.5	1	1	1	2	2	1	1	1	1	2",
		"Psychic":    	%w"1	1	1	1	1	0.5	1	2	1	1	1	1	2	1	1",
		"Normal":	    %w"1	1	1	1	1	1	1	1	1	1	0.5	1	1	0	1",
		"Fighting":    	%w"1	1	1	1	2	0.5	2	1	0.5	1	2	0.5	0.5	0	1",
		"Flying":	    %w"1	1	2	0.5	1	1	1	2	1	1	0.5	2	1	1	1",
		"Ground":	    %w"2	1	0.5	2	1	1	1	1	0	1	2	0.5	2	1	1",
		"Rock":	  %w"2	1	1	1	2	1	1	0.5	2	0.5	1	2	1	1	1",
		"Bug":	   %w"0.5	1	2	1	1	2	1	0.5	0.5	1	1	1	2	1	1",
		"Poison":	    %w"1	1	2	1	1	1	1	1	1	0.5	0.5	2	0.5	0.5	1",
		"Ghost":	 %w"1	1	1	1	1	1	0	1	1	1	1	1	1	2	1",
		"Dragon":	    %w" 1	 1	 1	 1	 1	 1	 1	 1	 1	 1	 1	 1	 1	 1	 2"
	}

		advantage_frame = Daru::DataFrame.new(advantage_table, index: advantage_table.keys)
	
	end

	# def initial_battle_state
	# 	@battle_state = {
	# 		userPokemon: {
	# 			currentPokemon: nil,
	# 			currentTeam: [
	# 				{
	# 					stats: user.team[0].pokemon,
	# 					hp: user.team[0].pokemon.hp,
	# 					alive: nil
	# 				},
	# 				{
	# 					stats: user.team[1].pokemon,
	# 					hp: user.team[1].pokemon.hp,
	# 					alive: nil
	# 				},
	# 				{
	# 					stats: user.team[2].pokemon,
	# 					hp: user.team[2].pokemon.hp,
	# 					alive: nil
	# 				},
	# 				{
	# 					stats: user.team[3].pokemon,
	# 					hp: user.team[3].pokemon.hp,
	# 					alive: nil
	# 				},
	# 				{
	# 					stats: user.team[4].pokemon,
	# 					hp: user.team[4].pokemon.hp,
	# 					alive: nil
	# 				},
	# 				{
	# 					stats: user.team[5].pokemon,
	# 					hp: user.team[5].pokemon.hp,
	# 					alive: nil
	# 				}
	# 		]},
	# 		# opponentPokemon: {
	# 		# 	currentPokemon: user.pokeballs[0].pokemon,
	# 		# 	currentTeam: [
	# 		# 		{pokemon1: user.pokeballs[0].pokemon, alive: nil},
	# 		# 		{pokemon2: user.pokeballs[1].pokemon, alive: nil},
	# 		# 		{pokemon3: user.pokeballs[2].pokemon, alive: nil},
	# 		# 		{pokemon4: user.pokeballs[3].pokemon, alive: nil},
	# 		# 		{pokemon5: user.pokeballs[4].pokemon, alive: nil},
	# 		# 		{pokemon6: user.pokeballs[5].pokemon, alive: nil}
	# 		# ]}
	# 		opponentPokemon: {
	# 			currentPokemon: nil,
	# 			currentTeam: [
	# 				{
	# 					stats: opponent.team[0].pokemon,
	# 					hp: opponent.team[0].pokemon.hp,
	# 					alive: nil
	# 					},
	# 				{
	# 					stats: opponent.team[1].pokemon,
	# 					hp: opponent.team[1].pokemon.hp,
	# 					alive: nil
	# 				},
	# 				{
	# 					stats: opponent.team[2].pokemon,
	# 					hp: opponent.team[2].pokemon.hp,
	# 					alive: nil
	# 				},
	# 				{
	# 					stats: opponent.team[3].pokemon,
	# 					hp: opponent.team[3].pokemon.hp,
	# 					alive: nil
	# 				},
	# 				{
	# 					stats: opponent.team[4].pokemon,
	# 					hp: opponent.team[4].pokemon.hp,
	# 					alive: nil
	# 				},
	# 				{
	# 					stats: opponent.team[5].pokemon,
	# 					hp: opponent.team[5].pokemon.hp,
	# 					alive: nil
	# 				}
	# 		]}
	# 	}

	# 	# firstUserPokemon = state[:userPokemon][:currentTeam][0]
	# 	# firstOpponentPokemon = state[:opponentPokemon][:currentTeam][0]
	# 	# # binding.pry
	# 	# state[:userPokemon][:currentPokemon] = state[:userPokemon][:currentTeam][0]
	# 	# state[:opponentPokemon][:currentPokemon] = state[:opponentPokemon][:currentTeam][0]
	# 	# state
	# 	# binding.pry
	# end 

	def set_battle_state(new_state)
		self.battle_state.merge(new_state)
	end 

	def set_initial_battle_state

		@battle_state = {
			user: {
				trainer: @user,
				currentPokemon: nil,
				currentTeam: []
			},
			opponent: {
				trainer: @opponent,
				currentPokemon: nil,
				currentTeam: []
			},
			turn: nil,
			winner: nil
		}

		@user.team.map { |pokeball| 
			@battle_state[:user][:currentTeam] << 
				{
					pokemon: pokeball.pokemon,
					hp: pokeball.pokemon.hp,
					alive: true
				}
		}

		@opponent.team.map { |pokeball| 
			@battle_state[:opponent][:currentTeam] << 
				{
					pokemon: pokeball.pokemon,
					hp: pokeball.pokemon.hp,
					alive: true
				}
		}

		@userCurrentPokemon = @battle_state[:user][:currentPokemon]
		@opponentCurrentPokemon = @battle_state[:opponent][:currentPokemon]

		@battle_state

	end


end

# while true
# 	Pokemon.all.each { |p| puts p.ascii sleep 1 } 
# end

	