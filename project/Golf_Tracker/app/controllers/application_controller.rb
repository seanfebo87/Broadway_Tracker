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

    post '/signup' do
        if params[:email] == "" || params[:password] == ""
            redirect to '/signup'
        else
            @user = User.create(email: params[:email], password: params[:password])
            @user.save
            session[:user_id] = @user.id
            redirect to '/homepage'
        end
    end


    get '/login' do
        if logged_in?
            redirect to '/homepage'
        else
            erb :login
        end
    end

    post '/login' do
         @user = User.find_by(email: params[:email])
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect to '/homepage'
        else
            erb :login
        end
    end

    get '/homepage' do
        if logged_in?
            @user = current_user
            erb :homepage
        else
            redirect to '/login'
        end
    end

    get '/logout' do
        if logged_in?
            session.clear
            redirect to 'login'
        else
            redirect to '/login'
        end
    end

end
