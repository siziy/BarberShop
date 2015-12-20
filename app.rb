#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error = 'something wrong!'
	erb :About
end

get '/visit' do
	erb :visit
end

post '/visit' do
	@userName = params[:userName]
	@phone = params[:phone]
	@dateTime = params[:dateTime]
	@barber = params[:barber]
	@color = params[:color]

	# ХЭШ
	hh = {  :userName => 'Введите имя',
			:phone => 'Введите телефон',
			:dateTime => 'Введите дату и время'
		 }


 	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

 	if @error != ''
 		return erb :visit
	end

	erb "OK, username is #{@userName}, #{@phone}, #{@dateTime}, #{@barber}, #{@color}"
end