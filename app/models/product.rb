class Product < ApplicationRecord
    validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
    validates :title, :description, presence: true
    validates :price, numericality: {greater_than_or_equal_to: 0.01}
    validates :title, uniqueness: true

    belongs_to :category
    validates :category_id, presence: true
    def self.expired_reserved_stock
        where("reserved_at < ?", 15.minutes.ago).where("reserved_quantity > ?", 0)
    end

    
    
    has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
