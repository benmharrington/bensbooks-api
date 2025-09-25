class Author < ApplicationRecord
  validates :name, presence: true
  validates :link, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message:  Messages::VALIDATIONS[:url_invalid] }, allow_blank: true
  validate :deathdate_after_birthdate

  has_many :books

  def deathdate_after_birthdate
    if birthdate.present? && deathdate.present? && deathdate < birthdate
      errors.add(:deathdate, Messages::VALIDATIONS[:deathdate_invalid])
    end
  end
end
