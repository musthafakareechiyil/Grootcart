class AddOfferFieldsToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :offer_discount_percentage, :decimal
    add_column :categories, :offer_end_date, :date
  end
end
