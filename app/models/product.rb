class Product < ApplicationRecord
    validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
    validates :title, :description, presence: true
    validates :price, numericality: {greater_than_or_equal_to: 0.01}
    validates :title, uniqueness: true
    validate :valid_offer_dates
    belongs_to :category
    validates :category_id, presence: true
    def self.expired_reserved_stock
        where("reserved_at < ?", 15.minutes.ago).where("reserved_quantity > ?", 0)
    end

    def valid_offer_dates
        if offer_start_date.present? && offer_end_date.present? && offer_start_date >= offer_end_date
          errors.add(:offer_start_date, "must be before the end date")
        end
    end

    def offer_price
        if category&.offer_discount_percentage.present? && category&.offer_end_date.present? && category.offer_end_date >= Date.today
          price - (price * category.offer_discount_percentage / 100)
        else
          price
        end
    end
    
    has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
