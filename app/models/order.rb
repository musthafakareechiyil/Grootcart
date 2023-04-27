class Order < ApplicationRecord

  attr_accessor :status

  ORDER_STATUS = {
    pending: 0,
    processing: 1,
    shipped: 2,
    delivered: 3,
    cancelled: 4
  }.freeze

  belongs_to :user
  has_many :order_items



end
