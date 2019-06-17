class CreatePokeballs < ActiveRecord::Migration[5.0]
  def change
  	create_table :pokeballs do |t|
  		t.integer :pokemon_id
  		t.integer :user_id
  	end
  end
end
