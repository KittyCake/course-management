module V1
  class User < Base
    before do
      unless @env['PATH_INFO'].include?('login') || @env['PATH_INFO'].include?('logout')
        authenticate!
      end
    end

    # 登入
    desc "login" do
    end

    params do
      requires :email, type: String, allow_blank: false
      requires :password, type: String, allow_blank: false
    end

    post '/users/login' do
      user = ::User.find_by_email(params[:email])

      if !user
        raise Errors::UnauthorizedError, "#{params[:email]} 帳號/密碼錯誤"
      end

      # 驗證密碼
      if ::BCrypt::Password.new(user.encrypted_password) != params[:password]
        raise Errors::UnauthorizedError, "帳號或密碼錯誤"
      end

      token = user.api_access_tokens.create!

      result = {
        id: user.id,
        token: token.key,
        is_admin: user.is_admin,
      }

      present result
    end

    # 登出
    desc "logout" do
    end

    params do
      # requires :id, type: Integer, allow_blank: false
    end

    post '/users/logout' do
      raise "無法找到此使用者" if !current_user

      ApiAccessToken.where(user_id: current_user.id).destroy_all

      result = {
        id: current_user.id,
        email: current_user.email,
      }

      present result
    end

    # index
    desc "回傳所有使用者資訊" do
      success model: V1::Entities::UserResult, examples: {
        "application/json": {
          results: [
            {
              id: 1,
              email: 'user@com.tw',
            },
          ],
        },
      }
      failure [
        [400, "找不到任何使用者"],
        [500, "unknown"],
      ]
    end

    get '/users', hidden: true do
      authenticate_admin!
      users = ::User.all
      present users.pluck(:id, :email)
    end

    # create
    desc "新建一個使用者" do
      success model: V1::Entities::UserResult, examples: {
        "application/json": {
          results: [
            {
              id: 1,
              email: 'user@com.tw',
            },
          ],
        },
      }
      failure [
        [400, "無法建立使用者"],
        [500, "unknown"],
      ]
    end
    params do
      requires :email, type: String, allow_blank: false
      requires :password, type: String, allow_blank: false
    end
    post '/users', hidden: true do
      authenticate_admin!
      user = ::User.create(declared(params, include_missing: false))

      result = {
        id: user.id,
        email: user.email,
      }

      present result
    rescue StandardError => e
      error! e
    end

    # patch
    desc "編輯一個使用者" do
      success model: V1::Entities::UserResult, examples: {
        "application/json": {
          results: [
            {
              id: 1,
              email: 'user@com.tw',
            },
          ],
        },
      }
      failure [
        [400, "無法建立使用者"],
        [500, "unknown"],
      ]
    end
    params do
      requires :email, type: String, allow_blank: false
      requires :password, type: String, allow_blank: false
    end
    patch '/users/:id', hidden: true do
      authenticate_admin!
      user = ::User.find_by(id: params[:id])
      user.update!(declared(params, include_missing: false).except(:id))

      result = {
        id: user.id,
        email: user.email,
      }

      present result
    rescue StandardError => e
      error! e
    end
    
    # delete
    desc "永久刪除一個使用者" do
      success model: V1::Entities::UserResult, examples: {
        "application/json": {
          results: [
            {
              id: 1,
              email: 'user@com.tw',
            },
          ],
        },
      }
      failure [
        [400, "無法建立使用者"],
        [500, "unknown"],
      ]
    end
    params do
      requires :id, type: Integer, allow_blank: false
    end
    delete '/users/:id', hidden: true do
      authenticate_admin!
      user = ::User.find_by(id: params[:id])
      user.destroy

      result = {
        id: user.id,
        email: user.email,
      }

      present result
    rescue StandardError => e
      error! e
    end
  end
end