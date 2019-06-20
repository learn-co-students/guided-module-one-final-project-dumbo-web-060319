class AddTeamFlagToPokeballs < ActiveRecord::Migration[5.0]
  def change
  	add_column :pokeballs, :on_team, :boolean
  end
end
