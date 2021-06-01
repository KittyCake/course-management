module V1::Entities
  class CategoryResult < Grape::Entity
    expose :id, documentation: { type: 'Integer', desc: '' }
    expose :name, documentation: { type: 'String', desc: '' }
  end
end