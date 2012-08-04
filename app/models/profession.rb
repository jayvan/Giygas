class Profession < ActiveRecord::Base
  attr_accessible :name
  has_many :recipes
end
