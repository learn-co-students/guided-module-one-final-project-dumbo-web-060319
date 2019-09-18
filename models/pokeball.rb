class Pokeball < ActiveRecord::Base
	belongs_to :user
	belongs_to :pokemon

	def view_stats_page(pokeball)
		puts "#{self.pokemon.ascii_color}"
		puts "POKEDEX: #{self.pokemon.id}  NAME: #{self.pokemon.name}"
		puts "STATS: HP #{self.pokemon.hp} ATK #{self.pokemon.attack.to_i} DEF #{self.pokemon.defense.to_i}"
		puts "TYPE: #{self.pokemon.element_type}"
	end 

end