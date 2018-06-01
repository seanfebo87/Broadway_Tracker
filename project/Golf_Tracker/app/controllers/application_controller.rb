require './config/environment'
require 'pry'
class ApplicationController < Sinatra::Base

    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, "golfsecret"
    end

    helpers do
        def logged_in?
            !!session[:user_id]
        end

        def current_user
            User.find(session[:user_id])
        end
    end

    get '/' do
        erb :index
    end

    get '/signup' do
        erb :signup
    end

    get '/login' do
        if logged_in?
            redirect to erb :index #add a homepage for logged in users.
        else
            erb :login
        end
    end

    post '/login' do
         @user = User.find_by(email: params[:email])
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect to :index #add a homepage for logged in users.
        else
            erb :login
        end
    end

end
