
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
	password = User.create_password(params[:pass_create])
	user = User.new(name: params[:name_create], password_hash: password )
	if user.valid?
		user.save
		session[:user_id] = user.id
		redirect '/user'
	else
		redirect '/login'
	end
end

post '/login' do
	user = User.login_check(params[:name_login],params[:pass_login])
	if user == false 
		redirect '/login'
	else
		session[:user_id] = user.id
		redirect '/user'
	end
end



get '/logout' do
	session.clear
	redirect '/'
end