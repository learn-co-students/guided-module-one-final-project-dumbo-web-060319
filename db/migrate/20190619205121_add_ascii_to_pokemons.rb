class AddAsciiToPokemons < ActiveRecord::Migration[5.0]
  def change
  	add_column :pokemons, :ascii, :string
  end
end
