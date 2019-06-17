class Pokeball < ActiveRecord::Base
	belongs_to :user
	belongs_to :pokemon
end