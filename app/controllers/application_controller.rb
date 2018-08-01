require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET')
    use Rack::Flash, :sweep => true

  end

  get "/" do
    erb :welcome
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def redirect_if_not_my_recipe(recipe)
      unless recipe.user == current_user
        flash[:message] = "You cannot edit other user's recipe."
        redirect '/recipes'
      end

    end
  end
end
