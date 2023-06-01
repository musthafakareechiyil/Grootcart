class AddUserIdToCoupons < ActiveRecord::Migration[7.0]
  def change
    add_reference :coupons, :user, null: true, foreign_key: true
  end
end
