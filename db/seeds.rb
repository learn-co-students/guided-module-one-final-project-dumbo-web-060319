require_relative '../models/pokemon.rb'
require_relative '../models/user.rb'
require 'json'
require 'faker'
require 'pry'

# Seed pokemons table with pokedex data
# This will not change
def seed_pokemon
	Pokemon.delete_all
	pokemons_seeds = JSON.load File.open './db/seeds.json'
	pokemons_seeds.each do |s|
		pokemon_hash = {}
		pokemon_hash[:name] = s["name"]
		pokemon_hash[:element_type] = s["element_type"]
		pokemon_hash[:hp] = s["base"]["HP"].to_f
		pokemon_hash[:attack] = s["base"]["Attack"].to_f 
		pokemon_hash[:defense] = s["base"]["Defense"].to_f
		pokemon_hash[:speed] = s["base"]["Speed"].to_f
		Pokemon.create(pokemon_hash)
	end
end

# Seed users table with fake names
def seed_users
	User.delete_all
	20.times do
		User.create({'name': Faker::Name.name, 'wins': 0, 'losses': 0})
	end
end

# Add 6 random pokemon to each user
def seed_pokeballs
	Pokeball.delete_all
	User.all.each do |user|
		6.times do
			new_pokeball = user.add_random_pokeball
			user.add_pokeball_to_team(new_pokeball)
		end
	end
end

seed_pokemon
seed_users
seed_pokeballs