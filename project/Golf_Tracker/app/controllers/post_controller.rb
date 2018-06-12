require './config/environment'
require 'rack-flash'
class PostController < ApplicationController
use Rack::Flash

    get '/posts/:id/new' do
            erb :'/users/new'
    end

    post '/posts/:id/new' do
        @user = User.find(session[:user_id])
        if params[:date] == "" || params[:course] == "" || params[:score] == ""
            flash[:message] = "Please fill out all fields."
            redirect to "/#{@user.id}/new"
        else
            @post = Post.create(date: params[:date], course: params[:course], score: params[:score])
            @user.posts << @post
            redirect to "/user/#{@user.id}"
        end
    end

    get '/posts/:id/edit' do
        @post = Post.find(params[:id])
        if logged_in? && @post && @post.user_id == session[:user_id]
            erb :'/users/edit'
        else
            redirect to '/'
        end

    end

    post '/posts/:id/edit' do
        @post = Post.find(params[:id])
        @post.update(date: params[:date], course: params[:course], score: params[:score])
        redirect to "/user/#{@post.user_id}"
    end

    get '/posts/:id/delete' do
        Post.find(params[:id]).delete
        redirect to '/'
    end
