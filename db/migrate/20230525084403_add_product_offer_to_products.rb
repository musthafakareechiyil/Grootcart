class AddProductOfferToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :offer_title, :string
    add_column :products, :offer_discount_percentage, :float
    add_column :products, :offer_start_date, :date
    add_column :products, :offer_end_date, :date
  end
end
