class Inbox < ApplicationRecord
  belongs_to :user
  validates :name, uniqueness: { case_sensitive: false }

  has_many :items, dependent: :destroy
end
