module V1::Auth
  class Authenticator
    def initialize(request)
      @request = request
    end

    def authenticate!
      check_token!
      token
    end

    def token
      @token = ApiAccessToken.joins(:user).where(
        key: @request.env['HTTP_AUTHORIZATION']&.sub(/^Bearer /, '')
      ).first
    end

    def check_token!
      return @request.env['HTTP_AUTHORIZATION']&.sub(/^Bearer /, '') unless token
    end
  end
end