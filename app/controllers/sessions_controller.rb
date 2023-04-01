class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(phone: params[:phone])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash.now[:alert] = "Invalid phone or password."
      render :new
    end
  end

  def destroy
  end
end
