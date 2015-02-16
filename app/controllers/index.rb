get '/' do
	@user = session[:user_id]
  erb :index
end
