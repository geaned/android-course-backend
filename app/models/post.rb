class Post < ApplicationRecord
  validates :title, presence: {message: ErrorMessage::INPUT_MISSING}, on: :create
end
