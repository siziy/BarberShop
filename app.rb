#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute('select * from barbers where name=?', [name]).length > 0
end

def seed_db db, barbers 

	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into barbers (name) values(?)', [barber]
		end
	end

end

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

before do 
	db = get_db
	@barbers = db.execute 'select * from barbers'
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

	db.execute 'CREATE TABLE IF NOT EXISTS 
		"barbers" 
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT, 
			"name" TEXT 
			
		)'

	seed_db db, ['Jessie Pinkman', 'Walter white', 'Gus Fring', 'Mike Ehrmantraut']

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

	erb "<h2>Спасибо, вы записались.</h2>"
end

get '/showusers' do
	db = get_db

	@results = db.execute 'select * from Users order by id desc'

	erb :showusers
end

