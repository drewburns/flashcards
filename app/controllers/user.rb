
get '/user' do
	if session[:user_id] == nil
		redirect '/login'
	else
		@user = User.find(session[:user_id])
		@rounds = @user.rounds
		@decks = Deck.all
		erb :user
	end
end

get '/login' do
	if session[:user_id] == nil
		erb :login
	else
		redirect '/user'
	end
end

post '/newuser' do
	user = User.new(name: params[:name_create], encrypted_password:  hash_password([:pass_create]))
	if user.valid?
		User.create(name: params[:name_create], encrypted_password:  hash_password(params[:pass_create]))
	else
		session[:user_id] = user.id
		redirect '/login'
	end
	redirect '/user'
end

post '/login' do
	user = User.where(name: params[:name_login])
	if user && user.password == hash_password(params[:pass_login])
		session[:user_id] = user.id
		redirect '/user'
	else
	 redirect '/login'
	end
end



get '/logout' do
	session.clear
	redirect '/'
end