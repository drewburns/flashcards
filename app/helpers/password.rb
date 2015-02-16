helpers do
  def hash_password(text)
  	include BCrypt
  BCrypt::Password.create(text)
    
  end
end