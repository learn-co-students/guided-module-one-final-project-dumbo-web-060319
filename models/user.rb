class User < ActiveRecord::Base
	has_many :pokeballs
	has_many :pokemons, through: :pokeballs

	def catch
		wild_pokemon = Pokemon.find_by(id: rand(1 .. Pokemon.all.length))
		puts "A wild #{wild_pokemon.name} appeared!"
		roll = rand(1 .. 100)
		if roll > 66
			puts "Congratulations! You caught #{wild_pokemon.name}."
			add_pokeball(wild_pokemon.id)
		else
			puts "#{wild_pokemon.name} got away."
		end
	end

	def add_pokeball(pokemon_id)
		new_pokeball = Pokeball.create(user_id: self.id, pokemon_id: pokemon_id)
	end

	def add_random_pokeball
		new_pokeball = Pokeball.create(user_id: self.id, pokemon_id: rand(1 .. Pokemon.all.length))
	end

	def team
		pokeballs.where(on_team: true)
	end

	def team_size
		team.count
	end

	def add_pokeball_to_team(pokeball)
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
		pokeballs.all
	end

	def view_pokemons_in_collection
		all_pokemons_in_collection.map {|p| p.pokemon.name}
	end


	def all_pokemons_on_team
		team.map {|pokeball| pokeball.pokemon.name}
	end

	def self.new_user(name)
		new_user = create(name: name)
		6.times do
			new_pokeball = new_user.add_random_pokeball
			new_user.add_pokeball_to_team(new_pokeball)
		end

		new_user
	end

end