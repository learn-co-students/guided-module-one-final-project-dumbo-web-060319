require 'pry'
class Pokemon < ActiveRecord::Base
    has_many :pokeballs
    has_many :users, through: :pokeballs
    
    def self.first_pokemon_id
        first.id
    end

    def self.last_pokemon_id
        last.id
    end
end