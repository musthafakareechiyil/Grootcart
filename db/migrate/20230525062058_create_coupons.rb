class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.string :code
      t.date :valid_from
      t.date :valid_until
      t.decimal :minimum_purchase_amount
      t.string :discount_type
      t.decimal :discount_value

      t.timestamps
    end
  end
end
