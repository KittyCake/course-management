module V1::Entities
  class UserResult < Grape::Entity
    expose :email, documentation: { type: 'String', desc: '' }
    expose :password, documentation: { type: 'String', desc: '' }
  end
end