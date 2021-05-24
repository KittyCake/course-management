module V1::Errors
  class Error < Grape::Exceptions::Base
    attr :code, :text

    def initialize(options = {})
      @code = options[:code] || 2000
      @text = options[:text] || ''
      @status = options[:status] || 400
      @message = { error: { code: @code, message: @text } }
    end
  end
end