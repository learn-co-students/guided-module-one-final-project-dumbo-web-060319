require_relative '../models/pokemon.rb'
require_relative '../models/user.rb'
require 'json'
require 'faker'

# Seed pokemons table with pokedex data
# This will not change
def seed_pokemon
	Pokemon.delete_all
	pokemons_seeds = JSON.load File.open './db/seeds.json'
	pokemons_seeds.each do |s|
		Pokemon.create(s)
	end
end

# Seed users table with fake names
def seed_users
	User.delete_all
	20.times do
		User.create({'name': Faker::Name.name, 'wins': 0, 'losses': 0})
	end
end

def seed_pokeballs
	Pokeball.delete_all
	User.all.each do |u|
		6.times do
			new_pokeball = u.create_random_pokeball
			u.add_pokeball_to_team(new_pokeball)
		end
	end
end

seed_pokemon
seed_users