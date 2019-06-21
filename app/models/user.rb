class User < ActiveRecord::Base
  has_many :watch_lists
  has_many :stocks, through: :watch_lists

end
