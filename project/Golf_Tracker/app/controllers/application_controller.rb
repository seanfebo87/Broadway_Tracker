require './config/environment'
require 'rack-flash'
require 'pry'
class ApplicationController < Sinatra::Base
use Rack::Flash

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
        if logged_in?
            redirect to "/#{session[:user_id]}"
        else
            erb :index
        end
    end

    get '/signup' do
        if logged_in?
            redirect to "/#{session[:user_id]}"
        else
            erb :signup
        end
    end

    post '/signup' do
        if params[:email] == "" || params[:username] == "" || params[:password] == ""
            flash[:message] = "Please fill out all fields."
            redirect to '/signup'
        elsif User.find_by_email(params[:email]) != nil
            flash[:message] = "This email is already being used."
            redirect to '/signup'
        else
            @user = User.create(email: params[:email], username: params[:username], password: params[:password])
            @user.save
            session[:user_id] = @user.id
            redirect to "/#{session[:user_id]}"
        end
    end


    get '/login' do
        if logged_in?
            redirect to "/#{session[:user_id]}"
        else
            erb :login
        end
    end

    post '/login' do
         @user = User.find_by(email: params[:email])
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect to "/#{@user.id}"
        elsif params[:email] == "" || params[:password] == ""
            flash[:message] = "Please fill out all fields."
            redirect to '/login'
        else
            flash[:message] = "Not valid information."
            redirect to '/login'
        end
    end

    get '/:id' do
            @user = User.find(params[:id])
            if logged_in? && @user && @user.id == session[:user_id]
            erb :'/users/show'
        else
            redirect to "/#{@user.id}"
        end
    end

    get '/:id/new' do
            erb :'/users/new'
    end

    post '/:id/new' do
        if params[:date] == "" || params[:course] == "" || params[:score] == ""
            flash[:message] = "Please fill out all fields."
            redirect to '/:id/new'
        else
            @post = Post.create(date: params[:date], course: params[:course], score: params[:score])
            @user = User.find(session[:user_id])
            @user.posts << @post
            redirect to "/#{@user.id}"
        end
    end

    get '/:id/edit' do
        @post = Post.find(params[:id])
        erb :'/users/edit'
    end


    post '/logout' do
        if logged_in?
            session.clear
            redirect to '/'
        else
            redirect to '/'
        end
    end

end
