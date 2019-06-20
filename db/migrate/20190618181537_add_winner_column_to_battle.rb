class AddWinnerColumnToBattle < ActiveRecord::Migration[5.0]
  def change
  	add_column :battles, :winner, :integer
  end
end
