class WatchListStock < ActiveRecord::Base
  belongs_to :stock
  belongs_to :watch_list
end
