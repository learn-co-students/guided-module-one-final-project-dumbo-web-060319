class Pokemon < ActiveRecord::Base
    has_many :pokeballs
    has_many :users, through: :pokeballs
end