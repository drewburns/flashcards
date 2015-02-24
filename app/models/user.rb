class User < ActiveRecord::Base
	require 'bcrypt'

  has_many :decks
  has_many :rounds

  validates :name, uniqueness: true

  def password
    @password ||= BCrypt::Password.new(password_hash)
  end

  def self.create_password(new_password)
    BCrypt::Password.create(new_password)
  end

	def self.login_check(username, password)
    user = User.where(name: username).first
    if user && user.password == password 
      user
    else
      false
    end
  end 


end
