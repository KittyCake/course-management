module V1
  class Base < APIBase
    version 'v1', using: :path

    include V1::ExceptionHandlers
    helpers ::V1::Helpers

    mount Course

    add_swagger_documentation(
      api_version: "v1", 
      hide_documentation_path: true, 
      hide_format: true,
    )
  end
end