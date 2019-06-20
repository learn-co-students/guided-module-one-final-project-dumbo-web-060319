class ChangePokemonColumnTypesToFloats < ActiveRecord::Migration[5.0]
  def change
    change_column :pokemons, :attack, :float
    change_column :pokemons, :defense, :float 
    change_column :pokemons, :speed, :float
  end
end
