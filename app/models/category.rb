class Category < ApplicationRecord
  has_many :products

  validates :name, presence: true, uniqueness: true
  validates :offer_discount_percentage, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :offer_end_date, presence: true, if: :offer_discount_percentage?

  def offer_discount_percentage?
    offer_discount_percentage.present?
  end
  
end
