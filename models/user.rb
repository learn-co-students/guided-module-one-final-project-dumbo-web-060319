class User < ActiveRecord::Base
	has_one :team
	has_many :pokeballs
	has_many :pokemons, through: :pokeballs

	def pokemon_names
		pokemons.map(&:name)
	end
end