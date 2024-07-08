
module V1
  class Books < Base

    resource :books do
      desc 'Get all books'
      get do
        authenticate!
        books = Book.includes(:tags).all # Eager load tags
        present books, with: Entities::Book
      end

      desc 'Get a specific book'
      params do
        requires :id, type: Integer, desc: 'Book ID'
      end
      get ':id' do
        authenticate!
        book = Book.includes(:tags).find(params[:id])
        present book, with: Entities::Book
      end

      desc 'Create a new book'
      params do
        requires :title, type: String, desc: 'Book title'
        requires :author, type: String, desc: 'Author name'
        optional :genre, type: String, desc: 'Genre'
        optional :publication_year, type: Integer, desc: 'Publication year'
        optional :tags, type: Array[String], desc: 'Tag'
      end
      post do
        authenticate!
        book = Book.new(declared(params.except(:tags), include_missing: false))

        if book.save
          params[:tags].each do |tag_name|
            tag = Tag.find_or_create_by(name: tag_name.strip)
            book.tags << tag
          end if params[:tags]
          present book, with: Entities::Book
        else
          error!(book.errors.full_messages, 422)
        end
      end

      desc 'Update a book'
      params do
        requires :id, type: Integer, desc: 'Book ID'
        optional :title, type: String, desc: 'Book title'
        optional :author, type: String, desc: 'Author name'
        optional :genre, type: String, desc: 'Genre'
        optional :publication_year, type: Integer, desc: 'Publication year'
        optional :tags, type: Array[String], desc: 'Tags'
      end
      put ':id' do
        authenticate!
        book = Book.find(params[:id])

        if book.update(declared(params.except(:tags), include_missing: false))
          book.tags.clear
          params[:tags].each do |tag_name|
            tag = Tag.find_or_create_by(name: tag_name.strip)
            book.tags << tag
          end if params[:tags]
          present book, with: Entities::Book
        else
          error!(book.errors.full_messages, 422)
        end
      end

      desc 'Delete a book'
      params do
        requires :id, type: Integer, desc: 'Book ID'
      end
      delete ':id' do
        authenticate!
        book = Book.find(params[:id])
        book.destroy
        status :no_content
        { message: 'Book deleted'}
      end
    end
  end
end
