class Address < ApplicationRecord
  belongs_to :user
  has_many :orders


  validates :address_type, :full_name, :email, :address, :state, :country, :postal_code, :phone_number, presence: true

  
  def full_address
    [address, state, country, postal_code].compact.join(", ")
  end

  def formatted_address
    "#{full_name}, #{address}, #{state}, #{country} #{postal_code}"
  end
  
end
