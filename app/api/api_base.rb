class APIBase < Grape::API
  # general setting
  format :json
  content_type :json, 'application/json'
  default_error_status 400

  mount V1::Base
end