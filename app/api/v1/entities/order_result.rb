module V1::Entities
  class OrderResult < Grape::Entity
    expose :course_id, documentation: { type: 'Integer', desc: '' }
    expose :price, documentation: { type: 'Integer', desc: '' }
    expose :expiration_date, documentation: { type: 'Datetime', desc: '' }
    expose :credit_card_number, documentation: { type: 'String', desc: '' }
    expose :credit_card_valid_thru_y, documentation: { type: 'Integer', desc: '' }
    expose :credit_card_valid_thru_m, documentation: { type: 'Integer', desc: '' }
    expose :credit_card_verification, documentation: { type: 'Integer', desc: '' }
  end
end