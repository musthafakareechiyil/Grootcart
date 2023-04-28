class ProductReservationWorker
    include Sidekiq::Worker
    
    def perform
      Product.where('reserved_quantity > 0').find_each do |product|
        if Time.now - product.reserved_at >= 15.minutes
          product.update(reserved_quantity: 0, reserved_at: nil, stock_quantity: product.stock_quantity + product.reserved_quantity)
          ActionCable.server.broadcast "product_channel", {id: product.id, reserved_quantity: 0, stock_quantity: product.stock_quantity}
        end
      end
    end
  end
  