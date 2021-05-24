module V1::Auth
  class Middleware < Grape::Middleware::Base
    def before
      if auth_provided?
        @env['v1.token'] = Authenticator.new(request, params).authenticate!
        @env['v1.user'] ||= @env['v1.token'].try(:user)
      end
    end

    def request
      @request ||= ::Grape::Request.new(env)
    end

    def params
      @params ||= request.params
    end

    def auth_provided?
      params[:access_key].present?
    end
  end
end