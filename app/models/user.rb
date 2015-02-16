class User < ActiveRecord::Base
	include BCrypt

  has_many :decks
  has_many :rounds

  validates :name, uniqueness: true

  def password
    @password ||= Password.new(password_hash)
  end




end
