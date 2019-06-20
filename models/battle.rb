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
		battle_winner.save
		battle_loser.save
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
		(((((((((2 * 50)/5)+2) * attacker.attack * 60)/defender.defense)/50)+2)*(1)*(Battle.rando255))/255).round
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

	def self.rando255
		rand(217..255)
	end

	def self.crit_rando
		rand(0..255)
	end 

	def self.rando100
		(rand(1..100).to_f / 100)
	end 

	def self.cirtical_hit?(attacker)

	end 


# 	Fir	Wat	Gra	Ele	Ice	Psy	Nor	Fgt	Fly	Gro	Rck	Bug	Poi	Gho	Drg
# Special attacks:
# Fire	0.5	0.5	2	1	2	1	1	1	1	1	0.5	2	1	1	0.5
# Water	2	0.5	0.5	1	1	1	1	1	1	2	2	1	1	1	0.5
# Grass	0.5	2	0.5	1	1	1	1	1	0.5	2	2	0.5	0.5	1	0.5
# Electric	1	2	0.5	0.5	1	1	1	1	2	0	1	1	1	1	0.5
# Ice	1	0.5	2	1	0.5	1	1	1	2	2	1	1	1	1	2
# Psychic	1	1	1	1	1	0.5	1	2	1	1	1	1	2	1	1
# Physical attacks:
# Normal	1	1	1	1	1	1	1	1	1	1	0.5	1	1	0	1
# Fighting	1	1	1	1	2	0.5	2	1	0.5	1	2	0.5	0.5	0	1
# Flying	1	1	2	0.5	1	1	1	2	1	1	0.5	2	1	1	1
# Ground	2	1	0.5	2	1	1	1	1	0	1	2	0.5	2	1	1
# Rock	2	1	1	1	2	1	1	0.5	2	0.5	1	2	1	1	1
# Bug	0.5	1	2	1	1	2	1	0.5	0.5	1	1	1	2	1	1
# Poison	1	1	2	1	1	1	1	1	1	0.5	0.5	2	0.5	0.5	1
# Ghost	1	1	1	1	1	0	0	1	1	1	1	1	1	2	1
# Dragon	?	?	?	?	?	?	?	?	?	?	?	?	?	?	?

# $type_advantage_hash = {

#   special_attacks:
#     {Fire:	"0.5	0.5	2	1	2	1	1	1	1	1	0.5	2	1	1	0.5",
#     Water:	"2	0.5	0.5	1	1	1	1	1	1	2	2	1	1	1	0.5",
#     Grass:	"0.5	2	0.5	1	1	1	1	1	0.5	2	2	0.5	0.5	1	0.5",
#     Electric:	"1	2	0.5	0.5	1	1	1	1	2	0	1	1	1	1	0.5",
#     Ice:	"1	0.5	2	1	0.5	1	1	1	2	2	1	1	1	1	2",
#     Psychic:	"1	1	1	1	1	0.5	1	2	1	1	1	1	2	1	1"
#     },

#   physical_attacks:
#     {Normal:	"1	1	1	1	1	1	1	1	1	1	0.5	1	1	0	1",
#     Fighting:	"1	1	1	1	2	0.5	2	1	0.5	1	2	0.5	0.5	0	1",
#     Flying:	"1	1	2	0.5	1	1	1	2	1	1	0.5	2	1	1	1",
#     Ground:	"2	1	0.5	2	1	1	1	1	0	1	2	0.5	2	1	1",
#     Rock:	"2	1	1	1	2	1	1	0.5	2	0.5	1	2	1	1	1",
#     Bug:	"0.5	1	2	1	1	2	1	0.5	0.5	1	1	1	2	1	1",
#     Poison:	"1	1	2	1	1	1	1	1	1	0.5	0.5	2	0.5	0.5	1",
#     Ghost:	"1	1	1	1	1	0	0	1	1	1	1	1	1	2	1",
#     Dragon:	"?	?	?	?	?	?	?	?	?	?	?	?	?	?	?"
#     }
# }

# $type_advantage_hash = {
# 	Fire:	"0.5	0.5	2	1	2	1	1	1	1	1	0.5	2	1	1	0.5",
#     Water:	"2	0.5	0.5	1	1	1	1	1	1	2	2	1	1	1	0.5",
#     Grass:	"0.5	2	0.5	1	1	1	1	1	0.5	2	2	0.5	0.5	1	0.5",
#     Electric:	"1	2	0.5	0.5	1	1	1	1	2	0	1	1	1	1	0.5",
#     Ice:	"1	0.5	2	1	0.5	1	1	1	2	2	1	1	1	1	2",
#     Psychic:	"1	1	1	1	1	0.5	1	2	1	1	1	1	2	1	1",
#     Normal:	"1	1	1	1	1	1	1	1	1	1	0.5	1	1	0	1",
#     Fighting:	"1	1	1	1	2	0.5	2	1	0.5	1	2	0.5	0.5	0	1",
#     Flying:	"1	1	2	0.5	1	1	1	2	1	1	0.5	2	1	1	1",
#     Ground:	"2	1	0.5	2	1	1	1	1	0	1	2	0.5	2	1	1",
#     Rock:	"2	1	1	1	2	1	1	0.5	2	0.5	1	2	1	1	1",
#     Bug:	"0.5	1	2	1	1	2	1	0.5	0.5	1	1	1	2	1	1",
#     Poison:	"1	1	2	1	1	1	1	1	1	0.5	0.5	2	0.5	0.5	1",
#     Ghost:	"1	1	1	1	1	0	0	1	1	1	1	1	1	2	1",
#     Dragon:	"?	?	?	?	?	?	?	?	?	?	?	?	?	?	?"
# }

$type_advantage_hash = 
	{
	Fire:	%w"0.5	0.5	2	1	2	1	1	1	1	1	0.5	2	1	1	0.5",
    Water:	%w"2	0.5	0.5	1	1	1	1	1	1	2	2	1	1	1	0.5",
    Grass:	%w"0.5	2	0.5	1	1	1	1	1	0.5	2	2	0.5	0.5	1	0.5",
    Electric:	%w"1	2	0.5	0.5	1	1	1	1	2	0	1	1	1	1	0.5",
    Ice:	%w"1	0.5	2	1	0.5	1	1	1	2	2	1	1	1	1	2",
    Psychic:	%w"1	1	1	1	1	0.5	1	2	1	1	1	1	2	1	1",
    Normal:	%w"1	1	1	1	1	1	1	1	1	1	0.5	1	1	0	1",
    Fighting:	%w"1	1	1	1	2	0.5	2	1	0.5	1	2	0.5	0.5	0	1",
    Flying:	%w"1	1	2	0.5	1	1	1	2	1	1	0.5	2	1	1	1",
    Ground:	%w"2	1	0.5	2	1	1	1	1	0	1	2	0.5	2	1	1",
    Rock:	%w"2	1	1	1	2	1	1	0.5	2	0.5	1	2	1	1	1",
    Bug:	%w"0.5	1	2	1	1	2	1	0.5	0.5	1	1	1	2	1	1",
    Poison:	%w"1	1	2	1	1	1	1	1	1	0.5	0.5	2	0.5	0.5	1",
    Ghost:	%w"1	1	1	1	1	0	0	1	1	1	1	1	1	2	1",
    Dragon:	%w"?	?	?	?	?	?	?	?	?	?	?	?	?	?	?"
}

$types = %w"Fire Water Grass Electic	Ice	Psychic	Normal Fighting	Flying Ground Rock Bug Poison Ghost	Dragon"

# {
#   special_attacks:
#     {Fire:	"Grass Bug",
#     Water:	"Fire Ground Rock",
#     Grass:	"Water Ground Rock",
#     Electric:	"Water Flying",
#     Ice: "Flying Ground Grass Dragon",
#     Psychic: "Fighting Poison"
#     },

#   physical_attacks:
#     {Normal:	"",
#     Fighting:	"Normal Rock Ice",
#     Flying:	"Fighting Bug Grass",
#     Ground:	"Poison Rock Fire Electric",
#     Rock:	"",
#     Bug:	"",
#     Poison:	"",
#     Ghost:	"",
#     Dragon:	""
#     }
# }

	def self.parser
		new_hash = {}
		$type_advantage_hash.each do |type, values|
			values.each do |value|
				$types.each do |type_key|
					new_hash[type] = type_key
					new_hash[type][type_key] = value
				end
			end
		end
		new_hash
		binding.pry
  	end

end