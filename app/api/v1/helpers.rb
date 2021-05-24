module V1::Helpers
  def authenticate!
    current_user or raise ::V1::Errors::AuthorizationError
  end
  
  def authenticate_admin!
    current_user.is_admin or raise ::V1::Errors::AuthorizationError
  end

  def current_user
    @current_user ||= env['v1.user']
  end
end