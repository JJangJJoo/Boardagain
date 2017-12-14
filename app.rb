require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'
require './model.rb'

set :bind, '0.0.0.0'

before do
  check_login
end

enable :sessions

get '/' do
  @posts = Post.all.reverse
  erb :index
end

get '/new' do
  erb :new
end

get '/create' do
  Post.create(
    title:  params["title"],
    content: params["content"]
  )
  redirect to '/'
end

get '/destroy/:id' do
  post = Post.get(params[:id])
  post.destroy
  redirect to '/'
end


get '/edit/:id' do
  @editpost = Post.get(params[:id]) #id하나의 모든정보 받는것?
  erb :edit
end

get '/update/:id' do
  post = Post.get(params[:id])
  post.update(
    title: params[:title],
    content: params[:content]
  )
  redirect to '/'
end

# get '/hello/:name' do
#   @name = params[:name]
#   erb :hello
# end
#
# get '/square/:number' do
#   num = params[:number].to_i
#   @sqnumber = num ** 2
#   erb :number
# end



get '/signup' do
    erb :signup
end


get '/register' do
  User.create(
    email: params["email"],
    password: params["password"]
  )
  redirect to '/'
end


get '/login' do
  erb :login
end

get '/login_session' do
  if User.first(email: params[:email])
    if User.first(email: params[:email]).password == params["password"]
      session[:email] = params["email"]
      @message = "Login Completed!"
    else
    @message = "Login failed"
    end
    else
    @message = "There is no user in our database!"

    erb :login_session
  end
end


def check_login
  unless session[:email]
    redirect to '/'
  end
end
