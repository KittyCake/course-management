class Course < ApplicationRecord
  belongs_to :category
  has_many :orders

  validates :availability_period, numericality: { greater_than: 0 }
  validates :availability_period, numericality: { less_than_or_equal_to: 30 }
end
