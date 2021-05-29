Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # devise_for :users

  root 'vue#index'

  mount APIBase => '/api'
  mount GrapeSwaggerRails::Engine => '/apidoc'

  get '*path' => 'vue#index'
end
