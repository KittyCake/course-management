module V1
  class Category < Base
    # index
    desc "回傳所有類型" do
      success model: V1::Entities::CategoryResult, examples: {
        "application/json": {
          results: [
            {
              id: 1,
              name: '語言',
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

    get '/categories' do
      categories = ::Category.all
      present categories, with: V1::Entities::CategoryResult
    end
  end
end