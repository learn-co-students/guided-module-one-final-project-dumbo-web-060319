require 'pry'
class User < ActiveRecord::Base
	has_many :pokeballs
	has_many :pokemons, through: :pokeballs

	def create_random_pokeball
		pokemon_id = rand(1..Pokemon.all.length)
		Pokeball.create(user_id: self.id, pokemon_id: pokemon_id)
	end

	def team
		pokeballs.where(on_team: true)
	end

	def team_size
		team.count
	end

	def add_pokeball_to_team(pokeball=create_random_pokeball)
		if team_size < 6
			pokeball.on_team = true
			pokeball.save
			"Adding #{pokeball.pokemon.name} to team..."
		else
			"Team is full. Try removing a Pokemon!"
		end
	end

	def remove_pokeball_from_team(pokeball=get_team.last)
		pokeball.on_team = false
		pokeball.save
	end

	def remove_pokeball_from_collection(pokeball)
		pokeball.delete
	end

	def all_pokemons_in_collection
		pokemons.map(&:name)
	end

	def all_pokemons_on_team
		team.map {|pokeball| pokeball.pokemon.name}
	end

	def self.new_user(name)
		new_user = create(name: name)
		6.times do
			new_user.add_pokeball_to_team
		end
		new_user.save

		new_user
	end

end