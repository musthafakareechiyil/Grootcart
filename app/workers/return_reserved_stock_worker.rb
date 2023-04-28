class ReturnReservedStockWorker
    include Sidekiq::Worker
  
    def perform(product_id)
      product = Product.find(product_id)
      if product.reserved_quantity > 0 && product.reserved_until < Time.current
        product.with_lock do
          product.update!(
            reserved_quantity: 0,
            reserved_until: nil,
            stock_quantity: product.stock_quantity + product.reserved_quantity
          )
        end
      end
    end
  end
  