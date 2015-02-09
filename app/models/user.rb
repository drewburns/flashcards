class User < ActiveRecord::Base
  has_many :decks
  has_many :rounds

  validates :name, uniqueness: true
end
