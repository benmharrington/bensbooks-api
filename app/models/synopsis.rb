class Synopsis < ApplicationRecord
  belongs_to :book
  belongs_to :user, optional: true
  has_many :synopsis_votes, dependent: :destroy
end
