require './config/environment'
require 'rack-flash'
class UserController < ApplicationController
use Rack::Flash

    get '/user/:id' do
        @user = User.find(params[:id])
        if logged_in? && @user && @user.id == session[:user_id]
            erb :'/users/show'
        else
            redirect to '/'
        end
    end
end
