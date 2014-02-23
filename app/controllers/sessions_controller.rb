class SessionsController < ApplicationController
  def new
    #renderöi kirjautumissivun
  end

  def omniauth
    user = User.from_omniauth(env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to root_url
  end

  def create
    user = User.find_by username: params[:username]

    if user.nil? or not user.authenticate params[:password]
      redirect_to :back, notice: "Username and password do not match"
    else
      session[:user_id] = user.id if not user.nil?
      redirect_to user_path(user), notice: "Welcome back!"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end

