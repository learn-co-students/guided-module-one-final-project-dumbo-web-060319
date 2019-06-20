class AddHpToPokeballs < ActiveRecord::Migration[5.0]
  def change
  	add_column :pokeballs, :hp, :integer, default: 5
  end
end
