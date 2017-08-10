class Dose < ApplicationRecord
  belongs_to :cocktail
  belongs_to :ingredient
  validates :ingredient_id, presence: true, allow_blank: false
  validates_uniqueness_of :cocktail, :scope => [:ingredient]
end
