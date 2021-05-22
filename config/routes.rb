Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount APIBase => '/api'
  mount GrapeSwaggerRails::Engine => '/apidoc'

  match "*path" => "errors#error_404", via: :all
end
