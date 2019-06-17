class Pokeball < ActiveRecord::Base
    belongs_to :pokemons 
    belongs_to :users
end