require './config/environment'
require 'pry'
class ApplicationController < Sinatra::Base

    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, "golfsecret"
    end

    get '/' do
        erb :index
    end

    get '/signup' do
        erb :signup
    end

    get '/login' do
        erb :login
    end
end
