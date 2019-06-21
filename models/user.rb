class User < ActiveRecord::Base
	has_many :pokeballs
	has_many :battles
	has_many :pokemons, through: :pokeballs

	def catch
		wild_pokemon = Pokemon.find_by(id: rand(Pokemon.first_pokemon_id .. Pokemon.last_pokemon_id))
		puts "A wild #{wild_pokemon.name} appeared!"
		roll = rand(1 .. 100)
		if roll > 66
			puts "Congratulations! You caught #{wild_pokemon.name}.".green
			new_pokeball = self.add_pokeball(wild_pokemon.id)
			add_pokeball_to_team(new_pokeball)
		else
			puts "#{wild_pokemon.name} got away.".red
		end
	end

	def add_pokeball(pokemon_id)
		new_pokeball = Pokeball.create(user_id: self.id, pokemon_id: pokemon_id)
	end

	def add_random_pokeball
        new_pokeball = Pokeball.create(user_id: self.id, pokemon_id: rand(Pokemon.first_pokemon_id .. Pokemon.last_pokemon_id))
    end

	def team
		pokeballs.where(on_team: true)
	end

	def not_on_team
		pokeballs.where(on_team: false) && pokeballs.where(on_team: nil)
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

	def remove_pokeball_from_team(pokeball)
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

	def view_pokeball
		
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
