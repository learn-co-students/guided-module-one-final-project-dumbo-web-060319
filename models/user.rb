class User < ActiveRecord::Base
	has_many :pokeballs
	has_many :battles
	has_many :pokemons, through: :pokeballs

	def catch
		pokedex_count = self.pokedex.count
		wild_pokemon = Pokemon.find_by(id: rand(Pokemon.first_pokemon_id .. Pokemon.last_pokemon_id))
		puts wild_pokemon.ascii_color
		puts "A wild #{wild_pokemon.name} appeared!"
		roll = rand(1 .. 100)
		if roll > 66
			puts "Congratulations! You caught #{wild_pokemon.name}.".green
			new_pokeball = self.add_pokeball(wild_pokemon.id)
			if self.pokedex.count == pokedex_count + 1
				puts "New Pokemon!! Pokedex: #{self.pokedex.count}".yellow
			end
			if self.team_size < 6 
				# binding.pry
				add_pokeball_to_team(new_pokeball)
			else 
				# binding.pry 
			end
		else
			puts "#{wild_pokemon.name} got away.".red
		end
	end

	def add_pokeball(pokemon_id)
		new_pokeball = Pokeball.create(user_id: self.id, pokemon_id: pokemon_id)
	end

	def add_random_pokeball
    new_pokeball = Pokeball.create(user_id: self.id, pokemon_id: rand(Pokemon.first_pokemon_id .. Pokemon.last_pokemon_id), on_team: true)
  end

	def team
		pokeballs.all.select { |pokemon| pokemon.on_team == true }
	end

	def not_on_team
		pokeballs.select { |pokemon| pokemon.on_team != true } 
	end		

	def consolidate_not_on_team
		#method for use outside of cli
		self.not_on_team.map { |pokemon| pokemon.on_team = false }
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
			pokeball.on_team = false
			"Team is full. Try removing a Pokemon!"
		end
	end

	def remove_pokeball_from_team(pokeball)
		if team_size == 1
			puts "You only have 1 pokemon left!"
		else 
			pokeball.on_team = false
			pokeball.save
			"Removing #{pokeball.pokemon.name} from team..."
		end
	end

	def remove_pokeball_from_collection(pokeball)
		pokeball.delete
	end

	def all_pokemons_in_collection
		pokeballs.all
	end

	# def view_pokemons_in_collection
	# 	all_pokemons_in_collection.map {|p| p.pokemon.name}
	# end

	def view_pokemons_in_collection
		# make the hash default to 0 so that += will work correctly
		new_array = []
		b = Hash.new(0)

		# iterate over the array, counting duplicate entries
		all_pokemons_in_collection.each do |v|
			b[v.pokemon.name] += 1
		end

		b.map do |k, v|
			new_array << "#{k}     x#{v}"
		end
		new_array.sort
	end 

	def pokedex
		pokedex = Set.new
		pokeballs.all.sort_by { |pokeball| pokeball.pokemon_id}.select {
			|pokeball| pokedex.add?(pokeball.pokemon_id)
		}
		# @pokedex_count = pokedex.count
		# return pokedex
	end

	def self.new_user(name)
		new_user = create(name: name)
		6.times do
			new_pokeball = new_user.add_random_pokeball
			new_user.add_pokeball_to_team(new_pokeball)
			# binding.pry
		end

		new_user
	end

	def battle_wins
		Battle.all.select { |battle| 
			battle.user_id == self.id || battle.opponent_id == self.id
		}.select {|battle| 
			battle.winner == self.id 
		}
	end 

	def battle_losses
		Battle.all.select { |battle| 
			battle.user_id == self.id || battle.opponent_id == self.id
		}.select {|battle| 
			battle.winner != self.id 
		}
	end

end
