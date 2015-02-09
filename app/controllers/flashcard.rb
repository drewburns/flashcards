post '/round/new' do
	round = Round.create(deck_id: params[:deck].to_i, user_id: session[:user_id])
	session[:round_id] =  round.id
	redirect '/play'
end

get '/play' do
	@round = Round.find(session[:round_id] )
	used_cards = []
	possible_cards = []
	@round.deck.cards.each do |card|
		used_cards << card if card.guesses.where(round_id: @round.id).size > 0
	end
	all_cards = @round.deck.cards
	if used_cards.size == 0
		@card = Card.find(all_cards.sample)
		erb :play
	else
		all_cards.each do |card|
			possible_cards << card unless used_cards.include?(card)
		end

		if possible_cards.size == 0
			session[:round_id] = nil
			redirect '/user'
		else
			@card = Card.find(possible_cards.sample)
			erb :play
		end
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



