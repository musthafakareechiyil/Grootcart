class CreateJoinTableCouponsOrders < ActiveRecord::Migration[7.0]
  def change
    create_join_table :coupons, :orders do |t|
      t.index [:coupon_id, :order_id]
      t.index [:order_id, :coupon_id]
    end
  end
end
