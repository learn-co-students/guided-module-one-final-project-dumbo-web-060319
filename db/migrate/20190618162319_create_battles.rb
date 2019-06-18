class CreateBattles < ActiveRecord::Migration[5.0]
  def change
  	create_table :battles do |t|
  		t.integer :user_id
  		t.integer :opponent_id
  		t.datetime :battle_date
  	end
  end
end
