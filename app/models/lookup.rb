class Lookup < ApplicationRecord
  belongs_to :user

  validates :search, presence: true
end
