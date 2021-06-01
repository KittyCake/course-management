module V1
  class Order < Base
    before { authenticate! }
    # index
    desc "回傳所有訂單資訊" do
      success model: V1::Entities::OrderResult, examples: {
        "application/json": {
          results: [
            {
              course_id: 1,
              price: 500,
              expiration_date: '2021-05-23T12:24:47.000Z',
            },
          ],
        },
      }
      failure [
        [400, "找不到任何訂單"],
        [500, "unknown"],
      ]
    end
    params do
      optional :category_ids, type: String, documentation: { #@TODO: 加上驗證
        description: "用逗號分隔開，中間無空格，例如：`1,2`",
      }
      optional :valid, type: Boolean
    end

    get '/orders' do
      orders = current_user.orders_detail(
        options: declared(params, include_missing: false)
      )

      present orders
    end

    # create
    desc "新建一個訂單" do
      success model: V1::Entities::OrderResult, examples: {
        "application/json": {
          results: [
            {
              course_id: 1,
              price: 500,
              expiration_date: '2021-05-23T12:24:47.000Z',
            }
          ],
        },
      }
      failure [
        [400, "無法建立訂單"],
        [500, "unknown"],
      ]
    end
    params do
      requires :course_id, type: Integer, allow_blank: false
      requires :credit_card_number, type: String, allow_blank: false
      requires :credit_card_valid_thru_y, type: Integer, allow_blank: false
      requires :credit_card_valid_thru_m, type: Integer, allow_blank: false
      requires :credit_card_verification, type: Integer, allow_blank: false
    end
    post '/orders' do
      order = current_user.orders.new(declared(params, include_missing: false))
      course = order.course

      raise StandardError, '此課程已經下架' unless course.for_sale

      valid_course = current_user.orders.
                                  where(course_id: params[:course_id]).
                                  where("expiration_date >= ?", Time.now)

      raise StandardError, '此課程的訂閱尚未到期，請於到期後再進行下單' if valid_course.present?

      order.price = course.price
      order.expiration_date = Time.now + course.availability_period.day
      order.save!

      present order, with: V1::Entities::OrderResult
    rescue StandardError => e
      error! e
    end
  end
end