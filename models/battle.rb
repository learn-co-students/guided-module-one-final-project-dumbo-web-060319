require 'pry'

class Battle < ActiveRecord::Base
	has_many :users
	has_many :pokeballs, through: :users

	attr_reader :user, :opponent
	attr_accessor :user_team, :opponent_team, :user_pokeball, :opponent_pokeball

	def self.do_battle(user, opponent)
		@user = user
		@opponent = opponent
		@user_team = @user.pokeballs(1..6)
		@opponent_team = @opponent.pokeballs(1..6)
		until @user_team.length == 0 or @opponent_team.length == 0 do
			@user_pokeball = @user_team[0]
			@opponent_pokeball = @opponent_team[0]
			self.fight(@user_pokeball, @opponent_pokeball)
		end
	end

	def self.fight(user_pokeball, opponent_pokeball)
		user_pokeball.hp = 5
		opponent_pokeball.hp = 5
		puts "#{@user.name} sent out #{user_pokeball.pokemon.name}!"
		puts "#{@opponent.name} sent out #{opponent_pokeball.pokemon.name}!"
		attack_order = order_roll
		until user_pokeball_hp <= 0 or opponent_pokeball_hp <=0 do
			attacker = attack_order[0]
			defender = attack_order[1]
			binding.pry
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