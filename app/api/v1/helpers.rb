module V1::Helpers
  def authenticate!
    current_user or raise ::V1::Errors::AuthorizationError
  end
  
  def authenticate_admin!
    current_user.try(:is_admin) or raise ::V1::Errors::AuthorizationError
  end

  def current_user
    @current_user ||= ::ApiAccessToken.find_by(
      key: @request.env['HTTP_AUTHORIZATION']&.sub(/^Bearer /, '')
    ).try(:user)
  end
end