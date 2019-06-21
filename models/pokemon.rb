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

    def self.type_color_hash

    {
        "Fire" => "red".to_sym,
        "Water" => "blue".to_sym, 
        "Grass" => "green".to_sym,
        "Electric" => "yellow".to_sym,
        "Ice" => "cyan".to_sym,
        "Psychic" => "magenta".to_sym,	
        "Normal" => "white".to_sym,
        "Fighting" => "red".to_sym,	
        "Flying" => "cyan".to_sym,
        "Ground" => "yellow".to_sym,
        "Rock" => "red".to_sym,
        "Bug" => "green".to_sym,
        "Poison" => "magenta".to_sym,
        "Ghost" => "magenta".to_sym,	
        "Dragon" => "cyan".to_sym
    }

    end

    def ascii_color 
        self.ascii.colorize Pokemon.type_color_hash[self.element_type]
    end 

end