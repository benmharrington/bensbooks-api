class SynopsisVote < ApplicationRecord
  belongs_to :user
  belongs_to :synopsis

  validates :vote, inclusion: { in: [ -1, 1 ] } # Ensure vote is either -1 or 1
end
