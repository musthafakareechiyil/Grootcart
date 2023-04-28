class User < ApplicationRecord
  has_many :addresses
  has_many :orders

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :phone_number, uniqueness: true
  validates :phone_number, phone: true, uniqueness: true


  def email_required?
  false
  end

  def email_changed?
  false
  end

  def current_user_cart
    "cart#{id}"
  end

  def add_to_cart(product_id)
    product = Product.find(product_id)
    if product.stock_quantity > 0
      $redis.hincrby current_user_cart, product_id, 1
      product.update(stock_quantity: product.stock_quantity - 1)
      return "Product added to cart"
    else
      return "Sorry, the product is out of stock"
    end
  end

  def remove_from_cart(product_id)
    $redis.hdel current_user_cart, product_id
    product = Product.find(product_id)
    product.update(stock_quantity: product.stock_quantity + 1)
  end

  def remove_one_from_cart(product_id)
    $redis.hincrby current_user_cart, product_id, -1
    product = Product.find(product_id)
    product.update(stock_quantity: product.stock_quantity + 1)
  end

  def cart_count
    quantities = $redis.hvals "cart#{id}"
    quantities.reduce(0) {|sum,qty| sum+ qty.ti_i}
  end

  def cart_total_price
    get_cart_products_with_qty.map { |product,qty| product.price * qty.to_i}.reduce(:+)
  end

  def get_cart_products_with_qty
    cart_ids = []
    cart_qtys = []
    ($redis.hgetall current_user_cart).map do |key, value|
      cart_ids << key
      cart_qtys << value
    end
    cart_products = Product.find(cart_ids)
    cart_products.zip(cart_qtys)
  end

  def purchase_cart_products!
    get_cart_products_with_qty.each do |product, qty|
      order = self.orders.create(user: self, address: address, payment_method: payment_method)
      self.orders.create(user: self, products: product, quantity: qty)
    end
    $redis.del current_user_cart
  end

  def remove_all_items_from_cart
    $redis.del current_user_cart
  end

end
