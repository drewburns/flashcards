class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :rounds
  has_many :cards

  validates :title, uniqueness: true
end
