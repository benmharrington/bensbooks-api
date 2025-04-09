class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
