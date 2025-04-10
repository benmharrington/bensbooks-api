class Book < ApplicationRecord
  validates :title, presence: true
  belongs_to :author
  has_many :synopses, dependent: :destroy
  has_many :ratings, dependent: :destroy
end
