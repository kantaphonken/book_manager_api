module V1
  module Entities
    class Tag < Grape::Entity
      expose :id, documentation: { type: Integer, desc: 'Tag ID' }
      expose :name, documentation: { type: String, desc: 'Tag name' }
    end
  end
end
