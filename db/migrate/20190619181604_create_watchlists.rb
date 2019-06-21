class CreateWatchlists < ActiveRecord::Migration[5.2]
  def change
    create_table :watch_lists do |table|
      table.string :name
      table.integer :user_id
    end
  end
end
