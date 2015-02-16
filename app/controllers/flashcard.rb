post '/round/new' do
	round = Round.create(deck_id: params[:deck].to_i, user_id: session[:user_id])
	session[:round_id] =  round.id
	redirect '/play'
end


get '/play' do
	redirect '/' if session[:round_id] == nil
	@round = Round.find(session[:round_id])
	used_cards = []
	@round.deck.cards.each do |card|
		used_cards << card if card.guesses.where(round_id: @round.id).size > 0
	end
	@card = nil
	valid_card = false
	if @round.deck.cards.size == @round.guesses.size
		session[:round_id]
		redirect '/user'
	else
		until valid_card == true do
			sample = @round.deck.cards.sample
			@card = sample unless used_cards.include?(sample)
			valid_card = true if @card != nil 
		end
			erb :play
	end
end

post '/round/:round/:card' do
	card = Card.find(params[:card])
	round = Round.find(params[:round])
	answer = params[:answer].downcase
	result = nil
	if answer == card.answer
		result = true
	else
		result = false
	end
	Guess.create(card_id: card.id, round_id: round.id, correct: result)
	session[:answer] = card.answer
	session[:result] = result
	redirect '/result'
end

get '/result' do
	@answer = session[:answer]
	@result = session[:result]
	session[:answer] = nil
	session[:result] = nil
	erb :result
end

get '/newdeck' do
	if session[:user_id] == nil 
		redirect '/login'
	else
		erb :newdeck
	end
end

get '/newcard' do
	if session[:user_id] == nil 
		redirect '/login'
	else
		@decks = Deck.where(user_id: session[:user_id])
		erb :newcard
	end
end

post '/newdeck' do
	title = params[:title]
	deck = Deck.new(title: title , user_id: session[:user_id])
	if deck.valid?
		Deck.create(title: title , user_id: session[:user_id])
	else
		@error = "This deck name already exists"
		erb :newdeck
	end
	redirect '/newcard'
end

post '/newcard' do
	Card.create(deck_id: params[:deck] , question: params[:question] , answer: params[:answer].downcase)
	redirect '/newcard'
end

