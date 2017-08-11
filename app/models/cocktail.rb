class Cocktail < ApplicationRecord
  has_many :doses, dependent: :destroy
  has_many :ingredients, through: :doses
  validates :name, uniqueness: true, presence: true, allow_blank: false
  validates :photo, presence: true, allow_blank: false
  mount_uploader :photo, PhotoUploader
end
