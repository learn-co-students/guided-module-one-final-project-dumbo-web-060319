class AddBaseStatsToAllPokemon < ActiveRecord::Migration[5.0]
  def change
    add_column :pokemons, :hp, :integer 
    add_column :pokemons, :attack, :integer 
    add_column :pokemons, :defense, :integer 
    add_column :pokemons, :speed, :integer
  end
end
