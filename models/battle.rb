class Battle < ActiveRecord::Base
	has_many :users
	has_many :pokeballs, through: :users

	attr_reader :user, :opponent
	attr_accessor :user_team, :opponent_team, :user_pokeball, :opponent_pokeball

	def self.do_battle(user, opponent)
		@user = user
		@opponent = opponent
		@user_team = Array.new(@user.pokeballs(1..6))
		@opponent_team = Array.new(@opponent.pokeballs(1..6))
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
		Battle.create(user_id: @user.id, opponent_id: @opponent.id, winner: battle_winner.id)
	end

	def self.fight(user_pokeball, opponent_pokeball)
		user_pokeball.hp = 5
		opponent_pokeball.hp = 5
		puts "\n\n"
		sleep 1
		puts "#{@user.name} sent out #{user_pokeball.pokemon.name}!"
		puts "#{@opponent.name} sent out #{opponent_pokeball.pokemon.name}!"
		puts "\n"
		sleep 1
		attack_order = order_roll
		until user_pokeball.hp <= 0 or opponent_pokeball.hp <=0 do
			attacker = attack_order[0]
			defender = attack_order[1]
			puts "#{attacker.pokemon.name} attacked!"
			attack_roll = self.attack
			if attack_roll == "miss"
				puts "#{attacker.pokemon.name} missed!"
			elsif attack_roll == "hit"
				puts "#{attacker.pokemon.name} hit #{defender.pokemon.name} for 1 damage!"
				defender.hp -= 1
			elsif attack_roll == "critical"
				puts "It's super effective!"
				defender.hp -= 5
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
		roll = rand(0 .. 100)
		if roll > 50
			[@user_pokeball, @opponent_pokeball]
		else
			[@opponent_pokeball, @user_pokeball]
		end
	end

	def self.attack
		roll = rand(0 .. 100)
		if roll < 30
			"miss"
		elsif roll > 80
			"critical"
		else
			"hit"
		end
	end
end