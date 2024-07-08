class Book < ApplicationRecord
  has_and_belongs_to_many :tags
  validates :title, :author, presence: true
end
