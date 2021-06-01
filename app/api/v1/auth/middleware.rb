module V1::Auth
  class Middleware < Grape::Middleware::Base
    def before
      if auth_provided?
        @env['v1.token'] = Authenticator.new(request).authenticate!
        @env['v1.user'] ||= @env['v1.token'].try(:user)
      end
    end

    def request
      @request ||= ::Grape::Request.new(env)
    end

    def auth_provided?
      @env['HTTP_AUTHORIZATION'].present?
    end
  end
end