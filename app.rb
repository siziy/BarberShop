#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS 
		"Users" 
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT, 
			"userName" TEXT, 
			"phone" TEXT, 
			"dateTime" TEXT, 
			"barber" TEXT, 
			"color" TEXT
		)'
end

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

	db = get_db
	db.execute 'insert into 
		"Users" 
		(
			userName,  
			phone, 
			dateTime, 
			barber, 
			color
		)
		values (?, ?, ?, ?, ?)', [@userName, @phone, @dateTime, @barber, @color] 

	erb "OK, username is #{@userName}, #{@phone}, #{@dateTime}, #{@barber}, #{@color}"
end

get '/showusers' do
	db = get_db

	@results = db.execute 'select * from Users order by id desc'
	
	erb :showusers
end

