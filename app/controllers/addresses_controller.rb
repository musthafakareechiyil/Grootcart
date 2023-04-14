class AddressesController < ApplicationController
  before_action :authenticate_user!
  def index
    @addresses = current_user.addresses
  end

  def new
    @address = current_user.addresses.build
  end

  def create
    @address = current_user.addresses.build(address_params)
    if @address.save
      redirect_to addresses_path, notice: "Address added successfully"
    else
      render :new
    end
  end
  
  def update
    @address = current_user.addresses.find(params[:id])
    if @address.update(address_params)
      redirect_to addresses_path, notice: "Address updated successfully"
    else
      render :edit
    end
  end
  

  private

  def address_params
    params.require(:address).permit(:address_type, :full_name, :email, :address, :state, :country, :postal_code, :phone_number)
  end  
end
