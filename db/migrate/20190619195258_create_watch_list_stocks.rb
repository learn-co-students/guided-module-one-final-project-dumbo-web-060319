class CreateWatchListStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :watch_list_stocks do |table|
      table.integer :watch_list_id
      table.integer :stock_id
    end
  end
end
