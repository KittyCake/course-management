module V1::ExceptionHandlers
  def self.included(base)
    base.instance_eval do
      rescue_from Grape::Exceptions::ValidationErrors do |e|
        rack_response({
          error: {
            code: 1001,
            message: e.message,
          }
        }.to_json, e.status)
      end

      rescue_from ActiveRecord::RecordNotFound do
        rack_response({ 'message' => '404 Not Found' }.to_json, 404)
      end

      route :any, '*path' do
        error!('404 Route Not Found', 404)
      end
    end
  end

end