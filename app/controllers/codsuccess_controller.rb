class CodsuccessController < ApplicationController
  def show
    if current_user.cart_count.zero?
      redirect_to orders_path
    end
  end
end
