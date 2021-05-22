module V1::Entities
  class CourseResult < Grape::Entity
    expose :name, documentation: { type: 'String', desc: '' }
    expose :category_id, documentation: { type: 'Integer', desc: '' }
    expose :price, documentation: { type: 'Integer', desc: '' }
    expose :currency, documentation: { type: 'Integer', desc: '' }
    expose :for_sale, documentation: { type: 'Boolean', desc: '' }
    expose :availability_period, documentation: { type: 'Integer', desc: '' }
    expose :url, documentation: { type: 'String', desc: '' }
    expose :description, documentation: { type: 'String', desc: '' }
  end
end