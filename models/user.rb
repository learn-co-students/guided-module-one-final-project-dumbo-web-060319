require 'pry'
class User < ActiveRecord::Base
	has_one :team
	has_many :pokeballs
	has_many :pokemons, through: :pokeballs

	def create_random_pokeball
		pokemon_id = rand(1..Pokemon.all.length)
		Pokeball.create(user_id: self.id, pokemon_id: pokemon_id)
	end

	def get_team
		pokeballs.where(on_team: true)
	end

	def add_pokeball_to_team(pokeball)
		pokeball.on_team = true
		pokeball.save
	end

	def pokemon_names
		pokemons.map(&:name)
	end
end