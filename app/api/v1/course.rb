module V1
  class Course < Base
    before { authenticate_admin! }
    
    # index
    desc "回傳所有課程資訊" do
      success model: V1::Entities::CourseResult, examples: {
        "application/json": {
          results: [
            {
              id: 1,
              name: '英語初級',
              category_id: 1,
              price: 500,
              currency: 'TWD',
              for_sale: true,
              availability_period: 90,
              url: 'https://www.google.com',
              description: '大家來說英語',
            },
          ],
        },
      }
      failure [
        [400, "找不到任何課程"],
        [500, "unknown"],
      ]
    end
    params do
    end

    get '/courses', hidden: true do
      courses = ::Course.all
      present courses, with: V1::Entities::CourseResult
    end

    # create
    desc "新建一個課程" do
      success model: V1::Entities::CourseResult, examples: {
        "application/json": {
          results: [
            {
              name: '英語初級',
              category_id: 1,
              price: 500,
              currency: 'TWD',
              for_sale: true,
              availability_period: 90,
              url: 'https://www.google.com',
              description: '大家來說英語',
            },
          ],
        },
      }
      failure [
        [400, "無法建立課程"],
        [500, "unknown"],
      ]
    end
    params do
      requires :name, type: String, allow_blank: false
      optional :category_id, type: Integer, default: 1, allow_blank: true
      optional :price, type: Integer, default: 1, allow_blank: true
      optional :currency, type: String, default: 'TWD', allow_blank: true
      optional :for_sale, type: Boolean, default: :false, allow_blank: true
      optional :availability_period, type: Integer, default: 30, allow_blank: true
      optional :url, type: String, default: '', allow_blank: true
      optional :description, type: String, default: '這個課程還沒有任何敘述', allow_blank: true
    end
    post '/courses', hidden: true do
      course = ::Course.create(declared(params, include_missing: false))

      present course, with: V1::Entities::CourseResult
    rescue StandardError => e
      error! e
    end

    # patch
    desc "編輯一個課程" do
      success model: V1::Entities::CourseResult, examples: {
        "application/json": {
          results: [
            {
              name: '英語初級',
              category_id: 1,
              price: 500,
              currency: 'TWD',
              for_sale: true,
              availability_period: 90,
              url: 'https://www.google.com',
              description: '大家來說英語',
            },
          ],
        },
      }
      failure [
        [400, "無法建立課程"],
        [500, "unknown"],
      ]
    end
    params do
      requires :id, type: Integer, allow_blank: false
      optional :name, type: String, allow_blank: true
      optional :category_id, type: Integer, allow_blank: true
      optional :price, type: Integer, allow_blank: true
      optional :currency, type: String, allow_blank: true
      optional :for_sale, type: Boolean, allow_blank: true
      optional :availability_period, type: Integer, allow_blank: true
      optional :url, type: String, allow_blank: true
      optional :description, type: String, allow_blank: true
    end
    patch '/courses/:id', hidden: true do
      course = ::Course.find_by(id: params[:id])
      course.update!(declared(params, include_missing: false).except(:id))

      present course, with: V1::Entities::CourseResult
    rescue StandardError => e
      error! e
    end
    
    # delete
    desc "永久刪除一個課程" do
      success model: V1::Entities::CourseResult, examples: {
        "application/json": {
          results: [
            {
              name: '英語初級',
              category_id: 1,
              price: 500,
              currency: 'TWD',
              for_sale: true,
              availability_period: 90,
              url: 'https://www.google.com',
              description: '大家來說英語',
            },
          ],
        },
      }
      failure [
        [400, "無法建立課程"],
        [500, "unknown"],
      ]
    end
    params do
      requires :id, type: Integer, allow_blank: false
    end
    delete '/courses/:id', hidden: true do
      course = ::Course.find_by(id: params[:id])
      course.destroy

      present course, with: V1::Entities::CourseResult
    rescue StandardError => e
      error! e
    end

    desc "幣別列表" do
      success examples: {
          "application/json": {
            results: [
              {
                id: 1,
                name: 1,
              },
            ],
          },
        }
        failure [
          [400, "無法建立課程"],
          [500, "unknown"],
        ]
    end
    params do
    end
    get '/courses/currencies' do
      currencies = ::Course.currencies.keys

      present currencies
    rescue StandardError => e
      error! e
    end
  end
end