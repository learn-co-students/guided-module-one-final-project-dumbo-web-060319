class Team < ActiveRecord::Base
	belongs_to :user
	has_one :user
	has_many :pokeballs
	has_many :pokemons, through: :pokeballs
end