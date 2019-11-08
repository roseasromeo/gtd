class Location < ApplicationRecord
  belongs_to :user
  validates_with NameValidator

  has_many :tasks, dependent: :destroy
end
