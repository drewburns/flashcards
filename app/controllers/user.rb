get '/user' do
	if session[:user_id] == nil
		redirect '/login'
	else
		@user = User.find(session[:user_id])
		@rounds = @user.rounds
		@decks = @user.decks
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

post '/login' do
	user = User.where(name: params[:user_input]).first_or_create
	session[:user_id] = user.id
	redirect '/user'
end



get '/logout' do
	session[:user_id] = nil
	redirect '/'
end