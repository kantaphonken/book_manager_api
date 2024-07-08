require "rails_helper"

RSpec.describe "Books API", type: :request do

  # Authentication setup
  let(:user) { create(:user) }
  let(:headers) { { "Authorization" => "Bearer #{user.authentication_token}" } }

  # Book setup
  let!(:books) { create_list(:book, 5) }
  let(:tags) { create_list(:tag, 2) }
  let(:book_id) { books.first.id }
  let(:valid_attributes) { attributes_for(:book).merge(tags: ["1", "2"]) }
  let(:invalid_attributes) { { title: "", author: "" } }
  let(:json) {JSON.parse(response.body)}

  # GET /api/books
  before do
    Rack::Attack.enabled = false
    user.update(authentication_token: SecureRandom.urlsafe_base64)
  end

  describe "GET /api/books" do
    before { get "/api/books", headers: headers }

    it "returns all books" do
      expect(json).not_to be_empty
      expect(json.size).to eq(5)
    end

    it "returns status code 200" do
      expect(response).to have_http_status(:ok)
    end
  end

  # GET /api/books/:id
  describe "GET /api/books/:id" do
    context "when the record exists" do
      before do
        book = books.first
        book.tags << tags
        book.save
        get "/api/books/#{book_id}", headers: headers
      end

      it "returns the book" do
        expect(json).not_to be_empty
        expect(json["id"]).to eq(book_id)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(:ok)
      end
      it "returns with tags" do
        expect(json["tags"]).to_not be_nil
      end
    end

    context "when the record does not exist" do
      let(:book_id) { 100 } # Invalid ID
      before { get "/api/books/#{book_id}", headers: headers }

      it "returns status code 404" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  # POST /api/books
  describe "POST /api/books" do
    context "when the request is valid" do
      before { post "/api/books", params: valid_attributes, headers: headers }

      it "creates a book" do
        expect(json["title"]).to eq(valid_attributes[:title])
      end

      it "returns status code 201" do
        expect(response).to have_http_status(:created)
      end
    end

    context "when the request is invalid" do
      before { post "/api/books", params: invalid_attributes, headers: headers }

      it "returns status code 422" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns a validation failure message" do
        expect(json["error"]).to all(match(/can't be blank/))
      end
    end
  end

  # PUT /api/books/:id
  describe "PUT /api/books/:id" do
    let(:new_attributes) { { title: "Updated Book Title" } }

    context "when the record exists" do
      before { put "/api/books/#{book_id}", params: new_attributes, headers: headers }

      it "updates the book" do
        expect(json["title"]).to eq(new_attributes[:title])
      end

      it "returns status code 200" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when the record does not exist" do
      let(:book_id) { 100 } # Invalid ID
      before { put "/api/books/#{book_id}", params: new_attributes, headers: headers }

      it "returns status code 404" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  # DELETE /api/books/:id
  describe "DELETE /api/books/:id" do
    context "when the record exists" do
      before { delete "/api/books/#{book_id}", headers: headers }

      it "returns status code 204" do
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
