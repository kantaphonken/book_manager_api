module V1
  module Entities
    class Book < Grape::Entity
      expose :id, documentation: { type: Integer, desc: 'Book ID' }
      expose :title, documentation: { type: String, desc: 'Book title' }
      expose :author, documentation: { type: String, desc: 'Author name' }
      expose :genre, documentation: { type: String, desc: 'Genre' }
      expose :publication_year, documentation: { type: Integer, desc: 'Publication year' }
      expose :tags, using: ::V1::Entities::Tag, documentation: { type: 'V1::Entities::Tag', is_array: true, desc: 'Associated tags' }, if: ->(book, _) { book.tags.any? }
    end
  end
end
