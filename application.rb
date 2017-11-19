require 'sinatra'
require 'sinatra/json'
require 'bundler'
Bundler.require # this will require every single gem in the Gemfile


require 'review' 
# instead of doing require relative (for the lib/review.rb file) you can do: ruby -Ilib application.rb
# -I flag allows you to include a folder to the ruby load path


DataMapper.setup(:default, 'sqlite::memory:') # this means that it will load sqlite in memory, meaning that everytime you restart your server the data will be lost. Checkout DataMapper docs for other configurations/settings
DataMapper.finalize
DataMapper.auto_migrate!





# To start the server: ruby -Ilib application.rb



get '/' do 
 "hello world\n"
end
# curl http://localhost:4567 

# hello world





get '/reviews' do
  content_type :json

  reviews = Review.all
  reviews.to_json # to_json method is from datamapper
end
# curl http://localhost:4567/reviews 

# [
#   {"id":1,"name":"Hello","text":"World","created_at":"2017-11-15T22:11:20-05:00","updated_at":"2017-11-15T22:11:20-05:00"},
#   {"id":2,"name":"Hi","text":"World","created_at":"2017-11-15T22:11:25-05:00","updated_at":"2017-11-15T22:11:25-05:00"}
# ]






get '/reviews/:id' do
  content_type :json

  review = Review.get(params[:id])
  review.to_json
end
# curl http://localhost:4567/reviews/1

# {"id":1,"name":"Hello","text":"World","created_at":"2017-11-15T22:33:20-05:00","updated_at":"2017-11-15T22:33:20-05:00"}







post '/reviews' do 
  content_type :json

  review = Review.new(params[:review])
  if review.save
    status 201
  else
    status 500
    json(review.errors.full_messages) # json method is from sinatra/json
  end
end
# curl -d "review[name]=Hello&review[text]=World" http://localhost:4567/reviews
# curl - X post http://localhost:4567/reviews -H "Content-Type:application/json" -d {"name":"New","text":"World"}






put '/reviews/:id' do
  content_type :json

  review = Review.get(params[:id]) # get is like find
  if review.update(params[:review])
    status 200
    json("Review was updated.")
  else
    status 500
    json(review.errors.full_messages)
  end
end
# curl -X PUT -d "review[name]=Goodbye" http://localhost:4567/reviews/1

# "Review was updated."








delete '/reviews/:id' do
  content_type :json

  review = Review.get(params[:id])
  if review.destroy
    status 200
    json("Review was removed.")
  else
    status 500
    json("There was a problem removing the review")
  end
end
# curl -X DELETE http://localhost:4567/reviews/1

# "Review was removed."















