class RemoveTeamIdFromUsers < ActiveRecord::Migration[5.0]
  def change
  	remove_column :users, :team_id
  end
end
