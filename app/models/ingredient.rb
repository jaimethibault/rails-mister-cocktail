class Ingredient < ApplicationRecord
  validates :name, uniqueness: true, presence: true, allow_blank: false
  has_many :doses
end
