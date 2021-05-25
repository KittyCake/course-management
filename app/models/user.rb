class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders
  has_many :courses, through: :orders

  def orders_detail(options: {})
    related_orders = orders.includes(course: :category)
    if options[:category_ids].present?
      related_orders = related_orders.where(
        courses: { category_id: options[:category_ids].split(',') }
      )
    end
    
    if options[:valid].present?
      operator = !!options[:valid] ? ">=" : "<="
      related_orders = related_orders.where(
        "expiration_date #{operator} ?", Time.now
      ) 
    end
    
    related_orders.map do |order|
      course = order.course
      {
        name: course.name,
        price: order.price,
        currency: course.currency,
        category: course.category.name,
        url: course.url,
        description: course.description,
        expiration_date: order.expiration_date,
        credit_card_number: order.credit_card_number,
        credit_card_valid_thru_y: order.credit_card_valid_thru_y,
        credit_card_valid_thru_m: order.credit_card_valid_thru_m,
        credit_card_verification: order.credit_card_verification,
      }
    end
  end
end
