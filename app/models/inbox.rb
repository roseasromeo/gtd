class Inbox < ApplicationRecord
  belongs_to :user
  validates_with NameValidator

  has_many :items, dependent: :destroy
end
