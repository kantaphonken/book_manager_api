module V1
  module Entities
    class User < Grape::Entity
      expose :id
      expose :email
    end
  end
end
