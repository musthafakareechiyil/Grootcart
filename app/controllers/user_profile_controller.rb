class UserProfileController < ApplicationController
  def index
  end

  def orders
  end

  def addresses
  end

  def account
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_profile_account_path, notice: "Profile updated successfully."
    else
      render :account
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :phone_number)
  end
end
